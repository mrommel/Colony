//
//  SKTextureExtension.swift
//  Colony
//
//  Created by Michael Rommel on 08.08.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit
import BinarySwift

enum DDSError: Error {

    case notValid(magic: UInt32)
    case wrong(headerSize: UInt32)
    case wrong(formatSize: UInt32)
    case error(named: String)
    case unsupportedDDSTextureFormat
}

enum DDSSurfaceFormat {
    case none
    case Dxt1
    case Dxt3
    case Dxt5
    case ColorBgraEXT
}

struct DDSFormat {
    let format: DDSSurfaceFormat
    let blockSize: Int
    let levelSize: Int
}

public struct DDSPixelFormat { //: DDS_PIXELFORMAT

    let formatSize: UInt32
    let formatFlags: UInt32
    let formatFourCC: UInt32
    let formatRGBBitCount: UInt32
    let formatRBitMask: UInt32
    let formatGBitMask: UInt32
    let formatBBitMask: UInt32
    let formatABitMask: UInt32

    init(reader: BinaryDataReader) throws {
        self.formatSize = try reader.read()
        guard self.formatSize == DDSHeaderData.DDS_PIXFMTSIZE else {
            throw DDSError.wrong(formatSize: self.formatSize)
        }

        self.formatFlags = try reader.read()
        self.formatFourCC = try reader.read()
        self.formatRGBBitCount = try reader.read()
        self.formatRBitMask = try reader.read()
        self.formatGBitMask = try reader.read()
        self.formatBBitMask = try reader.read()
        self.formatABitMask = try reader.read()
    }

    func evaluateFormatFor(width: Int, height: Int) throws -> DDSFormat {

        var format: DDSSurfaceFormat = .none
        var blockSize: Int = 0
        var levelSize: Int = 0

        if ((self.formatFlags & DDSHeaderData.DDPF_FOURCC) == DDSHeaderData.DDPF_FOURCC) {

            if (formatFourCC == DDSHeaderData.FOURCC_DXT1) {
                format = DDSSurfaceFormat.Dxt1
                blockSize = 8
            } else if (formatFourCC == DDSHeaderData.FOURCC_DXT3) {
                format = DDSSurfaceFormat.Dxt3
                blockSize = 16
            } else if (formatFourCC == DDSHeaderData.FOURCC_DXT5) {
                format = DDSSurfaceFormat.Dxt5
                blockSize = 16
            } else {
                throw DDSError.unsupportedDDSTextureFormat
            }

            if width > 0 {
                levelSize = Int((width + 3) / 4) * blockSize
            } else {
                levelSize = 1 * blockSize
            }

            if height > 0 {
                levelSize = levelSize * Int((height + 3) / 4)
            }

        } else if ((formatFlags & DDSHeaderData.DDPF_RGB) == DDSHeaderData.DDPF_RGB) {
            if (formatRGBBitCount != 32 ||
                    formatRBitMask != 0x00FF0000 ||
                    formatGBitMask != 0x0000FF00 ||
                    formatBBitMask != 0x000000FF ||
                    formatABitMask != 0xFF000000) {

                throw DDSError.unsupportedDDSTextureFormat
            }

            format = DDSSurfaceFormat.ColorBgraEXT
            levelSize = (((Int(width) * Int(self.formatRGBBitCount)) + 7) / 8) * Int(height)

        } else {
            throw DDSError.unsupportedDDSTextureFormat
        }

        return DDSFormat(format: format, blockSize: blockSize, levelSize: levelSize)
    }
    
    var hasAlphaPixels: Bool {
        return self.formatFlags & 0x1 > 0
    }
}

struct DDSHeaderData {

    static let DDS_MAGIC: UInt32 = 0x20534444
    static let DDS_HEADERSIZE: UInt32 = 124
    static let DDS_PIXFMTSIZE: UInt32 = 32
    static let DDSCAPS_TEXTURE: UInt32 = 0x1000

    static let DDSCAPS_MIPMAP: UInt32 = 0x400000
    static let DDPF_FOURCC: UInt32 = 0x4
    static let FOURCC_DXT1: UInt32 = 0x31545844
    static let FOURCC_DXT3: UInt32 = 0x33545844
    static let FOURCC_DXT5: UInt32 = 0x35545844
    static let DDPF_RGB: UInt32 = 0x40

    // magic
    let magic: UInt32

    // Texture info
    let headerSize: UInt32
    let flags: UInt32
    let height: Int32
    let width: Int32
    let dwPitchOrLinearSize: UInt32 // unused
    let dwDepth: UInt32 // unused
    var mipMapCount: Int32

    // Format info
    let pixelFormat: DDSPixelFormat

    let dwCaps1, dwCaps2, dwCaps3, dwCaps4: UInt32

    // calculated
    let ddsFormat: DDSFormat

    init(reader: BinaryDataReader) throws {

        // File should start with 'DDS '
        self.magic = try reader.read()
        guard self.magic == DDSHeaderData.DDS_MAGIC else {
            throw DDSError.notValid(magic: self.magic)
        }

        // Texture info
        self.headerSize = try reader.read()
        self.flags = try reader.read()
        self.height = try reader.read()
        self.width = try reader.read()
        self.dwPitchOrLinearSize = try reader.read()
        self.dwDepth = try reader.read()
        self.mipMapCount = try reader.read()

        guard self.headerSize == DDSHeaderData.DDS_HEADERSIZE else {
            throw DDSError.wrong(headerSize: self.headerSize)
        }

        // "Reserved"
        _ = try reader.read(4 * 11)

        // Pixel Format info
        self.pixelFormat = try DDSPixelFormat(reader: reader)

        // dwCaps "stuff"
        self.dwCaps1 = try reader.read()
        guard (self.dwCaps1 & DDSHeaderData.DDSCAPS_TEXTURE) > 0 else {
            throw DDSError.error(named: "wrong dds caps texture")
        }
        self.dwCaps2 = try reader.read()
        guard self.dwCaps2 == 0 else {
            throw DDSError.error(named: "dds caps 2 should be 0")
        }
        self.dwCaps3 = try reader.read() // dwCaps3, unused
        self.dwCaps4 = try reader.read() // dwCaps4, unused

        // "Reserved"
        let _: UInt32 = try reader.read()

        // Mipmap sanity check
        if ((self.dwCaps1 & DDSHeaderData.DDSCAPS_MIPMAP) != DDSHeaderData.DDSCAPS_MIPMAP) {
            self.mipMapCount = 1
        }

        // Determine texture format
        self.ddsFormat = try self.pixelFormat.evaluateFormatFor(width: Int(self.width), height: Int(self.height))

        print("format: \(self.ddsFormat.format)")
        print("levelSize: \(self.ddsFormat.levelSize)")
        print("blockSize: \(self.ddsFormat.blockSize)")
    }
    
    var hasMipMaps: Bool {
        return self.dwCaps1 & DDSHeaderData.DDSCAPS_MIPMAP > 0
    }
}

typealias ArrayEntry = (UInt8)
extension Array  {
    
    static func copy(source: [UInt8], sourceStartIndex: Int, target: inout [UInt8], targetStartIndex: Int, length: Int) {
        
        for i in 0..<length {
            target[targetStartIndex + i] = source[sourceStartIndex + i]
        }
    }
}

class DDSFile {

    let ddsHeaderData: DDSHeaderData
    let decodedData: Data
    
    init(url: URL?, flipVertically: Bool = false) {

        guard let url = url else {
            fatalError("url not valid")
        }

        do {
            let data = try Data(contentsOf: url, options: .mappedIfSafe)
            let binaryData = BinaryData(data: data, bigEndian: false)
            let reader = BinaryDataReader(binaryData)

            self.ddsHeaderData = try DDSHeaderData(reader: reader)
            //print(ddsHeaderData)

            let restBytes = data.count - 128
            let compressedBinaryData = try reader.read(restBytes) // data 128 total header size
            var compressedData = Data(bytes: compressedBinaryData.data, count: restBytes)
            
            DDSFile.postProcessDDSTexture(
                width: Int(self.ddsHeaderData.width), height: Int(self.ddsHeaderData.height), bytesPerPixel: 4,
                hasMipmaps: self.ddsHeaderData.hasMipMaps, ddsMipmapLevelCount: Int(self.ddsHeaderData.mipMapCount),
                data: &compressedData, flipVertically: flipVertically)
            
            self.decodedData = try DDSFile.decodeDXTToARGB(dxtVersion: ddsHeaderData.ddsFormat.format, compressedData: compressedData, width: Int(ddsHeaderData.width), height: Int(ddsHeaderData.height), pixelFormat: ddsHeaderData.pixelFormat, mipmapCount: Int(ddsHeaderData.mipMapCount))

        } catch {
            fatalError("Error: \(error)")
        }
    }
    
    func texture() -> SKTexture {
        
        return SKTexture(data: self.decodedData, size: CGSize(width: Int(self.ddsHeaderData.width), height: Int(self.ddsHeaderData.height)))
    }
    
    static func postProcessDDSTexture(width: Int, height: Int, bytesPerPixel: Int, hasMipmaps: Bool, ddsMipmapLevelCount: Int, data: inout Data, flipVertically: Bool) {
        
        assert(width > 0 && height > 0 && bytesPerPixel > 0 && ddsMipmapLevelCount > 0); // && data != nil)
        
        // Flip mip-maps if necessary and generate missing mip-map levels.
        var mipMapLevelWidth = width
        var mipMapLevelHeight = height
        var mipMapLevelIndex = 0
        var mipMapLevelDataOffset = 0
        
        var dataArray: [UInt8] = [UInt8](repeating: 0, count:data.count)
        data.copyBytes(to: &dataArray, count: data.count)
        
        // While we haven't processed all of the mipmap levels we should process.
        while mipMapLevelWidth > 1 || mipMapLevelHeight > 1 {
            let mipMapDataSize = mipMapLevelWidth * mipMapLevelHeight * bytesPerPixel
            // If the DDS file contains the current mipmap level, flip it vertically if necessary.
            if flipVertically && mipMapLevelIndex < ddsMipmapLevelCount {
                
                DDSFile.flip2DSubArrayVertically(srcData: &dataArray, startIndex: mipMapLevelDataOffset, rows: mipMapLevelHeight, bytesPerRow: mipMapLevelWidth * bytesPerPixel)
            }
            // Break after optionally flipping the first mipmap level if the DDS texture doesn't have mipmaps.
            guard hasMipmaps else {
                break
            }
            // Generate the next mipmap level's data if the DDS file doesn't contain it.
            if mipMapLevelIndex + 1 >= ddsMipmapLevelCount {
                DDSFile.downscale4Component32BitPixelsX2(srcBytes: dataArray, srcStartIndex: mipMapLevelDataOffset, srcRowCount: mipMapLevelHeight, srcColumnCount: mipMapLevelWidth, dstBytes: &dataArray, dstStartIndex: mipMapLevelDataOffset + mipMapDataSize)
            }
            // Switch to the next mipmap level.
            mipMapLevelIndex += 1
            mipMapLevelWidth = mipMapLevelWidth > 1 ? (mipMapLevelWidth / 2) : mipMapLevelWidth
            mipMapLevelHeight = mipMapLevelHeight > 1 ? (mipMapLevelHeight / 2) : mipMapLevelHeight
            mipMapLevelDataOffset += mipMapDataSize
        }
        
        data = Data(bytes: dataArray, count: data.count)
    }
    
    static func flip2DSubArrayVertically(srcData: inout [UInt8], startIndex: Int, rows : Int, bytesPerRow: Int) {
        
        assert(startIndex >= 0 && rows >= 0 && bytesPerRow >= 0 && (startIndex + (rows * bytesPerRow)) <= srcData.count)
    
        var tmpRow: [UInt8] = [UInt8](repeating: 0, count: bytesPerRow)
        let lastRowIndex = rows - 1
    
        for rowIndex in 0..<(rows / 2) {
            let otherRowIndex = lastRowIndex - rowIndex
            let rowStartIndex = startIndex + (rowIndex * bytesPerRow)
            let otherRowStartIndex = startIndex + (otherRowIndex * bytesPerRow)
    
            Array<Any>.copy(source: srcData, sourceStartIndex: otherRowStartIndex, target: &tmpRow, targetStartIndex: 0, length: bytesPerRow) // other -> tmp
            Array<Any>.copy(source: srcData, sourceStartIndex: rowStartIndex, target: &srcData, targetStartIndex: otherRowStartIndex, length: bytesPerRow) // row -> other
            Array<Any>.copy(source: tmpRow, sourceStartIndex: 0, target: &srcData, targetStartIndex: rowStartIndex, length: bytesPerRow) // tmp -> row
        }
    }
    
    static func downscale4Component32BitPixelsX2(srcBytes: [UInt8], srcStartIndex: Int, srcRowCount: Int, srcColumnCount: Int, dstBytes: inout [UInt8], dstStartIndex: Int) {
    
        let bytesPerPixel = 4
        let componentCount = 4
        assert(srcStartIndex >= 0 && srcRowCount >= 0 && srcColumnCount >= 0 && (srcStartIndex + (bytesPerPixel * srcRowCount * srcColumnCount)) <= srcBytes.count)
    
        let dstRowCount = srcRowCount / 2
        let dstColumnCount = srcColumnCount / 2
        assert(dstStartIndex >= 0 && (dstStartIndex + (bytesPerPixel * dstRowCount * dstColumnCount)) <= dstBytes.count)
        
        for dstRowIndex in 0..<dstRowCount {
            for dstColumnIndex in 0..<dstColumnCount {
                let srcRowIndex0 = 2 * dstRowIndex
                let srcColumnIndex0 = 2 * dstColumnIndex
                let srcPixel0Index = (srcColumnCount * srcRowIndex0) + srcColumnIndex0
                
                var srcPixelStartIndices = [Int](repeating: 0, count: 4)
                srcPixelStartIndices[0] = srcStartIndex + (bytesPerPixel * srcPixel0Index) // top-left
                srcPixelStartIndices[1] = srcPixelStartIndices[0] + bytesPerPixel // top-right
                srcPixelStartIndices[2] = srcPixelStartIndices[0] + (bytesPerPixel * srcColumnCount) // bottom-left
                srcPixelStartIndices[3] = srcPixelStartIndices[2] + bytesPerPixel // bottom-right
                
                let dstPixelIndex = (dstColumnCount * dstRowIndex) + dstColumnIndex
                let dstPixelStartIndex = dstStartIndex + (bytesPerPixel * dstPixelIndex)
                
                for componentIndex in 0..<componentCount {
                    
                    var averageComponent: UInt16 = 0x0F
                    for srcPixelIndex in 0..<srcPixelStartIndices.count {
                        averageComponent += UInt16(srcBytes[srcPixelStartIndices[srcPixelIndex] + componentIndex])
                    }
                    
                    averageComponent /= UInt16(srcPixelStartIndices.count)
                    dstBytes[dstPixelStartIndex + componentIndex] = UInt8(averageComponent)
                }
            }
        }
    }

    static func decodeDXTToARGB(dxtVersion: DDSSurfaceFormat, compressedData: Data, width: Int, height: Int, pixelFormat: DDSPixelFormat, mipmapCount: Int) throws -> Data {

        let alphaFlag = pixelFormat.hasAlphaPixels // pixelFormat.dwFlags.contains(.alphaPixels)
        let containsAlpha = alphaFlag // || (pixelFormat.dwRGBBitCount == 32 && pixelFormat.dwABitMask != 0)

        let reader = BinaryDataReader(BinaryData(data: compressedData))

        var argb = Data(count: DDSFile.calculateMipMappedTextureDataSize(width: width, height: height, bytesPerPixel: 4))
        var mipMapWidth = width
        var mipMapHeight = height
        var baseARGBIndex = 0
        for _ in 0..<mipmapCount {
            for rowIndex in stride(from: 0, to: mipMapHeight, by: 4) {
                for columnIndex in stride(from: 0, to: mipMapWidth, by: 4) {
                    let colors: [Color32]

                    switch dxtVersion { // Doing a switch instead of using a delegate for speed.
                    case .Dxt1:
                        colors = try decodeDXT1TexelBlock(reader, containsAlpha: containsAlpha)
                    case .Dxt3:
                        colors = try decodeDXT3TexelBlock(reader)
                    case .Dxt5:
                        colors = try decodeDXT5TexelBlock(reader)
                    default:
                        fatalError("Tried decoding a DDS file using an unsupported DXT format: DXT \(dxtVersion))")
                    }

                    copyDecodedTexelBlock(decodedTexels: colors, argb: &argb, baseARGBIndex: baseARGBIndex, baseRowIndex: rowIndex, baseColumnIndex: columnIndex, textureWidth: mipMapWidth, textureHeight: mipMapHeight)
                }
            }
            baseARGBIndex += mipMapWidth * mipMapHeight * 4
            mipMapWidth /= 2
            mipMapHeight /= 2
        }
        return argb
    }

    static func decodeDXT1TexelBlock(_ r: BinaryDataReader, colorTable: [Color16]) throws -> [Color32] {

        assert(colorTable.count == 4)
        // Read pixel color indices.
        var colorIndices = [Int](repeating: 0, count: 16)
        let colorIndexBytes = try r.read(4)
        let bitsPerColorIndex = 2
        for rowIndex in 0..<4 {
            let rowBaseColorIndexIndex = 4 * rowIndex
            let rowBaseBitOffset = 8 * rowIndex
            for columnIndex in 0..<4 {
                // Color indices are arranged from right to left.
                let bitOffset = rowBaseBitOffset + (bitsPerColorIndex * (3 - columnIndex))
                colorIndices[rowBaseColorIndexIndex + columnIndex] = Int(getBits(bitOffset: UInt32(bitOffset), bitCount: UInt32(bitsPerColorIndex), bytes: colorIndexBytes.data))
            }
        }
        // Calculate pixel colors.
        var colors = [Color32]();
        colors.reserveCapacity(16)
        for i in 0..<16 {
            let index = colorIndices[i]
            colors.append(Color32(color: colorTable[index]))
        }
        return colors
    }

    static func getBits(bitOffset: UInt32, bitCount: UInt32, bytes: [UInt8]) -> UInt64 {

        assert(bitCount <= 64 && (bitOffset + bitCount) <= (8 * bytes.count))

        var bits: UInt64 = 0
        var remainingBitCount = bitCount
        var byteIndex = bitOffset / 8
        var bitIndex = bitOffset - (8 * byteIndex)

        while (remainingBitCount > 0) {
            // Read bits from the byte array.
            let numBitsLeftInByte = 8 - bitIndex
            let numBitsReadNow = min(remainingBitCount, numBitsLeftInByte)
            let unmaskedBits = (UInt64(bytes[Int(byteIndex)])) >> UInt64(8 - (bitIndex + numBitsReadNow))
            let bitMask: UInt64 = UInt64(0xFF) >> UInt64(8 - numBitsReadNow)
            let bitsReadNow = unmaskedBits & bitMask

            // Store the bits we read.
            bits = bits << UInt64(numBitsReadNow)
            bits |= bitsReadNow

            // Prepare for the next iteration.
            bitIndex += numBitsReadNow

            if (bitIndex == 8) {
                byteIndex += 1
                bitIndex = 0
            }

            remainingBitCount -= numBitsReadNow
        }

        return bits
    }

    static func decodeDXT1TexelBlock(_ reader: BinaryDataReader, containsAlpha: Bool) throws -> [Color32] {
        // Create the color table.
        var colorTable: [Color16] = []
        colorTable.reserveCapacity(4)
        colorTable.append(Color16(value: try reader.read()))
        colorTable.append(Color16(value: try reader.read()))

        if !containsAlpha {
            colorTable.append(Color16.lerp(min: colorTable[0], max: colorTable[1], value: 1.0 / 3.0))
            colorTable.append(Color16.lerp(min: colorTable[0], max: colorTable[1], value: 2.0 / 3.0))
        }
        else {
            colorTable.append(Color16.lerp(min: colorTable[0], max: colorTable[1], value: 1.0 / 2.0))
            colorTable.append(Color16(red: 0, green: 0, blue: 0))
        }
        // Calculate pixel colors.
        return try decodeDXT1TexelBlock(reader, colorTable: colorTable)
    }

    static func decodeDXT3TexelBlock(_ reader: BinaryDataReader) throws -> [Color32] {
        
        // Read compressed pixel alphas.
        var compressedAlphas: [UInt8] = []
        compressedAlphas.reserveCapacity(16)
        
        for _ in 0..<4 {
            let v0: UInt16 = try reader.read()
            let compressedAlphaRow = Int(v0)
            for columnIndex in 0..<4 {
                // Each compressed alpha is 4 bits.
                compressedAlphas.append(UInt8((compressedAlphaRow >> (columnIndex * 4)) & 0xF))
            }
        }
        
        // Calculate pixel alphas.
        var alphas = [UInt8](); alphas.reserveCapacity(16)
        for i in 0..<16 {
            let alphaPercent = Float(compressedAlphas[i] / 15)
            alphas.append(UInt8((alphaPercent * 255).rounded()))
        }
        // Create the color table.
        var colorTable = [Color16]();
        colorTable.reserveCapacity(4)
        let c0: UInt16 = try reader.read()
        colorTable.append(Color16(value: c0))
        let c1: UInt16 = try reader.read()
        colorTable.append(Color16(value: c1))
        colorTable.append(Color16.lerp(min: colorTable[0], max: colorTable[1], value: 1.0 / 3.0))
        colorTable.append(Color16.lerp(min: colorTable[0], max: colorTable[1], value: 2.0 / 3.0))
        
        // Calculate pixel colors.
        let colors = try decodeDXT1TexelBlock(reader, colorTable: colorTable)
        /*for i in 0..<16 {
            colors[i].alpha = alphas[i]
        }*/
        
        return colors
    }

    static func decodeDXT5TexelBlock(_ reader: BinaryDataReader) throws -> [Color32] {
        
        // Create the alpha table.
        var alphaTable = [Float]();
        alphaTable.reserveCapacity(8)
        let val0: UInt8 = try reader.read()
        alphaTable.append(Float(val0))
        let val1: UInt8 = try reader.read()
        alphaTable.append(Float(val1))
        if alphaTable[0] > alphaTable[1] {
            for i in 0..<6 {
                alphaTable.append(Float.lerp(min: alphaTable[0], max: alphaTable[1], value: Float(1 + i) / 7.0))
            }
        }
        else {
            for i in 0..<4 {
                alphaTable.append(Float.lerp(min: alphaTable[0], max: alphaTable[1], value: Float(1 + i) / 5.0))
            }
            alphaTable.append(0)
            alphaTable.append(255)
        }

        // Read pixel alpha indices.
        /*var alphaIndices = [Int]();
        alphaIndices.reserveCapacity(16)
        var alphaIndexBytesRow0 = try reader.read(3)
        alphaIndexBytesRow0.reverse() // Take care of little-endianness.
        var alphaIndexBytesRow1 = try reader.read(3) // Take care of little-endianness.
        alphaIndexBytesRow1.reverse() // Take care of little-endianness.
        let bitsPerAlphaIndex = 3
        alphaIndices.append(Int(Utils.getBits(21, bitsPerAlphaIndex, alphaIndexBytesRow0)))
        alphaIndices.append(Int(Utils.getBits(18, bitsPerAlphaIndex, alphaIndexBytesRow0)))
        alphaIndices.append(Int(Utils.getBits(15, bitsPerAlphaIndex, alphaIndexBytesRow0)))
        alphaIndices.append(Int(Utils.getBits(12, bitsPerAlphaIndex, alphaIndexBytesRow0)))
        alphaIndices.append(Int(Utils.getBits(9, bitsPerAlphaIndex, alphaIndexBytesRow0)))
        alphaIndices.append(Int(Utils.getBits(6, bitsPerAlphaIndex, alphaIndexBytesRow0)))
        alphaIndices.append(Int(Utils.getBits(3, bitsPerAlphaIndex, alphaIndexBytesRow0)))
        alphaIndices.append(Int(Utils.getBits(0, bitsPerAlphaIndex, alphaIndexBytesRow0)))
        alphaIndices.append(Int(Utils.getBits(21, bitsPerAlphaIndex, alphaIndexBytesRow1)))
        alphaIndices.append(Int(Utils.getBits(18, bitsPerAlphaIndex, alphaIndexBytesRow1)))
        alphaIndices.append(Int(Utils.getBits(15, bitsPerAlphaIndex, alphaIndexBytesRow1)))
        alphaIndices.append(Int(Utils.getBits(12, bitsPerAlphaIndex, alphaIndexBytesRow1)))
        alphaIndices.append(Int(Utils.getBits(9, bitsPerAlphaIndex, alphaIndexBytesRow1)))
        alphaIndices.append(Int(Utils.getBits(6, bitsPerAlphaIndex, alphaIndexBytesRow1)))
        alphaIndices.append(Int(Utils.getBits(3, bitsPerAlphaIndex, alphaIndexBytesRow1)))
        alphaIndices.append(Int(Utils.getBits(0, bitsPerAlphaIndex, alphaIndexBytesRow1)))*/
        
        // Create the color table.
        var colorTable = [Color16]();
        colorTable.reserveCapacity(4)
        let c0: UInt16 = try reader.read()
        colorTable.append(Color16(value: c0))
        let c1: UInt16 = try reader.read()
        colorTable.append(Color16(value: c1))
        colorTable.append(Color16.lerp(min: colorTable[0], max: colorTable[1], value: 1.0 / 3.0))
        colorTable.append(Color16.lerp(min: colorTable[0], max: colorTable[1], value: 2.0 / 3.0))
        
        // Calculate pixel colors.
        let colors = try decodeDXT1TexelBlock(reader, colorTable: colorTable)
        //for i in 0..<16 {
            //colors[i].alpha = UInt8(alphaTable[alphaIndices[i]].rounded())
        //}
        return colors
    }

    static func copyDecodedTexelBlock(decodedTexels: [Color32], argb: inout Data, baseARGBIndex: Int, baseRowIndex: Int, baseColumnIndex: Int, textureWidth: Int, textureHeight: Int) {
        for i in 0..<4 { // row
            for j in 0..<4 { // column
                let rowIndex = baseRowIndex + i
                let columnIndex = baseColumnIndex + j
                // Don't copy padding on mipmaps.
                if (rowIndex < textureHeight && columnIndex < textureWidth) {
                    let decodedTexelIndex = (4 * i) + j
                    let color = decodedTexels[decodedTexelIndex]
                    let argbPixelOffset = (textureWidth * rowIndex) + columnIndex
                    let basePixelARGBIndex = baseARGBIndex + (4 * argbPixelOffset)
                    argb[basePixelARGBIndex] = color.alpha
                    argb[basePixelARGBIndex + 1] = color.red
                    argb[basePixelARGBIndex + 2] = color.green
                    argb[basePixelARGBIndex + 3] = color.blue
                }
            }
        }
    }

    static func calculateMipMappedTextureDataSize(width: Int, height: Int, bytesPerPixel: Int) -> Int {
        //Assert(baseTextureWidth > 0 && baseTextureHeight > 0 && bytesPerPixel > 0);
        var dataSize: Int = 0
        var currentWidth: Int = width
        var currentHeight: Int = height

        while (true) {
            dataSize += currentWidth * currentHeight * bytesPerPixel
            if (currentWidth == 1 && currentHeight == 1) {
                break
            }
            currentWidth = currentWidth > 1 ? (currentWidth / 2) : currentWidth
            currentHeight = currentHeight > 1 ? (currentHeight / 2) : currentHeight
        }
        return dataSize
    }
}

// https://github.com/FNA-XNA/FNA/blob/5ac67cea830dd333330c72ae17556b7881454ddf/src/Graphics/Texture2D.cs
/*extension SKTexture {

    public convenience init(ddsUrl url: URL?) {

        let ddsFile = DDSFile(url: url)
        
        self = ddsFile.
        
        guard let url = url else {
            fatalError("url not valid")
        }

        do {
            let data = try Data(contentsOf: url, options: .mappedIfSafe)
            let binaryData = BinaryData(data: data, bigEndian: false)
            let reader = BinaryDataReader(binaryData)

            let ddsHeaderData = try DDSHeaderData(reader: reader)
            print(ddsHeaderData)

            let restBytes = data.count - 128
            let compressedTextureData = try reader.read(restBytes) // data 128 total header size



            //let pixelData: BinaryData = try reader.read(ddsHeaderData.levelSize)
            let resultData: Data = Data(bytes: compressedTextureData.data, count: restBytes)


            print(resultData)

            let size: CGSize = CGSize(width: Int(ddsHeaderData.width), height: Int(ddsHeaderData.height))

            self.init(data: resultData, size: size)
        } catch {
            fatalError("Error: \(error)")
        }
    }
}*/
