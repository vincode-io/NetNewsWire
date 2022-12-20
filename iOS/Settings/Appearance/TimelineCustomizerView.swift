//
//  TimelineCustomizerView.swift
//  NetNewsWire-iOS
//
//  Created by Stuart Breckenridge on 20/12/2022.
//  Copyright © 2022 Ranchero Software. All rights reserved.
//

import SwiftUI


struct TimelineCustomizerView: View {
	
	@StateObject private var appDefaults = AppDefaults.shared
	
    var body: some View {
		List {
			Section {
				ZStack {
					Picker(selection: $appDefaults.timelineIconSize) {
						ForEach(IconSize.allCases, id: \.self) { size in
							Text(size.description)
						}
					} label: {
						Text("ICON_SIZE", tableName: "Settings")
					}
				}
				.padding(.horizontal, 16)
				.padding(.vertical, 4)
				.listRowInsets(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
				.background(
					RoundedRectangle(cornerRadius: 8)
						.foregroundColor(Color(uiColor: UIColor.secondarySystemGroupedBackground))
				)
			}
			.listRowInsets(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30))
			.listRowBackground(Color.clear)
			.listRowSeparator(.hidden)
			
			Section {
				ZStack {
					Picker(selection: $appDefaults.timelineNumberOfLines) {
						ForEach(1...5, id: \.self) { size in
							Text("\(size)")
						}
					} label: {
						Text("NUMBER_OF_LINES", tableName: "Settings")
					}
				}
				.padding(.horizontal, 16)
				.padding(.vertical, 4)
				.listRowInsets(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
				.background(
					RoundedRectangle(cornerRadius: 8)
						.foregroundColor(Color(uiColor: UIColor.secondarySystemGroupedBackground))
				)
			}
			.listRowInsets(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30))
			.listRowBackground(Color.clear)
			.listRowSeparator(.hidden)
		
			Section {
				withAnimation {
					timeLinePreviewRow
						.listRowInsets(EdgeInsets(top: 8, leading: 4, bottom: 4, trailing: 24))
				}
				
			}
		}
		.listStyle(.grouped)
		.navigationTitle(Text("TIMELINE_LAYOUT", tableName: "Settings"))
		.onAppear {
			
		}
    }
	
	var timeLinePreviewRow: some View {
		HStack(alignment: .top, spacing: 6) {
			VStack {
				Circle()
					.foregroundColor(Color(uiColor: AppAssets.primaryAccentColor))
					.frame(width: 12, height: 12)
				Spacer()
			}.frame(width: 12)
			VStack {
				Image("faviconTemplateImage")
					.renderingMode(.template)
					.resizable()
					.frame(width: appDefaults.timelineIconSize.size.width, height: appDefaults.timelineIconSize.size.height)
					.foregroundColor(Color(uiColor: AppAssets.primaryAccentColor))
				Spacer()
			}.frame(width: appDefaults.timelineIconSize.size.width)
			VStack(alignment: .leading, spacing: 4) {
				Text("Enim ut tellus elementum sagittis vitae et. Nibh praesent tristique magna sit amet purus gravida quis blandit. Neque volutpat ac tincidunt vitae semper quis lectus nulla. Massa id neque aliquam vestibulum morbi blandit. Ultrices vitae auctor eu augue. Enim eu turpis egestas pretium aenean pharetra magna. Eget gravida cum sociis natoque. Sit amet consectetur adipiscing elit. Auctor eu augue ut lectus arcu bibendum. Maecenas volutpat blandit aliquam etiam erat velit. Ut pharetra sit amet aliquam id diam maecenas ultricies. In hac habitasse platea dictumst quisque sagittis purus sit amet.")
					.bold()
					.lineLimit(appDefaults.timelineNumberOfLines)
				HStack {
					Text("Feed name")
						.foregroundColor(.secondary)
						.font(.caption)
					Spacer()
					Text("08:51")
						.foregroundColor(.secondary)
						.font(.caption)
				}.padding(0)
			}
		}
		.edgesIgnoringSafeArea(.all)
		.padding(.vertical, 4)
		.padding(.leading, 4)
	}
}

struct TimelineCustomizerView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineCustomizerView()
    }
}