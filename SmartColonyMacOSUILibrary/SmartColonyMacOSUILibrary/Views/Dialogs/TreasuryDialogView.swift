//
//  TreasuryDialogView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 22.08.21.
//

import SwiftUI

struct TreasuryGroupBoxStyle: GroupBoxStyle {

    var color: Color
    
    func makeBody(configuration: Configuration) -> some View {

        VStack(alignment: .leading) {
            
            configuration.label
                .font(.headline)
                .foregroundColor(color)
            
            configuration.content
                .padding(.leading, 8)
                .padding(.trailing, 8)
                .padding(.bottom, 8)
                .padding(.top, 4)
        }
        .padding(.top, 2)
        .padding(.bottom, 2)
        .padding(.leading, 6)
        .padding(.trailing, 6)
        .background(Color(.controlBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
    }
}

struct TreasuryDialogView: View {
    
    @ObservedObject
    var viewModel: TreasuryDialogViewModel

    public init(viewModel: TreasuryDialogViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {
        Group {
            VStack(spacing: 10) {
                HStack {

                    Spacer()

                    Text("Gold per turn")
                        .font(.title2)
                        .bold()
                        .padding()

                    Spacer()
                }
                
                GroupBox(label: Text("Income")
                            ) {
                    VStack(alignment: .leading, spacing: 8) {
                        
                        Text(self.viewModel.goldFromCities) + Text(" from cities")
                        Text(self.viewModel.goldFromDeals) + Text(" from deals")
                        Text(self.viewModel.goldFromTradeRoutes) + Text(" from trade routes")
                        
                        Divider()
                        
                        Text("Sum: \(self.viewModel.goldIncome) \(Image(nsImage: self.viewModel.goldImage()))")
                    }
                    .frame(width: 270)
                }
                .groupBoxStyle(TreasuryGroupBoxStyle(color: .green))
                
                GroupBox(label: Text("Expenses")
                            .font(.headline)) {
                    VStack(alignment: .leading, spacing: 8) {
                        
                        Text(self.viewModel.goldForCityMaintenance) + Text(" from cities")
                        Text(self.viewModel.goldForUnitMaintenance) + Text(" from units")
                        Text(self.viewModel.goldForDeals) + Text(" from deals")
                        
                        Divider()
                        
                        Text("Sum: \(self.viewModel.goldExpenses) \(Image(nsImage: self.viewModel.goldImage()))")
                    }
                    .frame(width: 270)
                }
                .groupBoxStyle(TreasuryGroupBoxStyle(color: .red))
                
                Spacer()

                Button(action: {
                    self.viewModel.closeDialog()
                }, label: {
                    Text("Okay")
                })
            }
            .padding(.bottom, 45)
            .padding(.leading, 45)
            .padding(.trailing, 45)
        }
        .frame(width: 400, height: 450, alignment: .top)
        .background(
            Image(nsImage: ImageCache.shared.image(for: "grid9-dialog"))
                .resizable(capInsets: EdgeInsets(all: 45))
        )
    }
}

#if DEBUG
struct TreasuryDialogView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)
        let viewModel = TreasuryDialogViewModel()

        TreasuryDialogView(viewModel: viewModel)
    }
}
#endif
