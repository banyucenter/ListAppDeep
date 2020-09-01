//
//  ContentView.swift
//  ListAppDeep
//
//  Created by Ipung Dev Center on 01/09/20.
//  Copyright © 2020 Banyu Center. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView{
            Home()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home: View {
    //global data state
    @EnvironmentObject var data : ItemModel
    //if edit mode active
    @State private var editMode = EditMode.inactive
    
    var body: some View {
        VStack{
            //field add data
            HStack{
                TextField("Enter title", text: $data.newTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                addButton
            }
            .padding(.horizontal)
            
            //display data array at list
            List {
                ForEach(Array(data.items.enumerated()), id: \.offset){offset, item in
                    NavigationLink(destination: DetailView(data: item, index: offset)){
                        Text(item.title)
                    }
                }
                .onDelete(perform: data.onDelete)
                .onMove(perform: data.onMove)
            }
        }
        .navigationBarTitle("Title List")
        .navigationBarItems(leading: EditButton())
        .environment(\.editMode, $editMode)
    }
    
    //Add button view
    private var addButton : some View {
        //if edit mode active / not active
        switch editMode {
        case .inactive:
            return AnyView(Button(action: {self.data.onAdd(title: self.data.newTitle)}) {
                HStack{
//                    Text("Add")
                    Image(systemName: "plus")
                }
                .padding()
                .background(Color.orange)
                .foregroundColor(Color.white)
                .cornerRadius(5)
            })
        default:
            return AnyView(EmptyView())
        }
    }
}

//detail view for edit form
struct DetailView : View {
    @EnvironmentObject var datam : ItemModel
    
    //state for bind new title
    @State var newTitleValue : String = ""
    
    //data props
    var data : Item
    
    //position index props
    let index : Int
    
    @State private var isShowingHome = false
    
    var body: some View {
        
        VStack(alignment: .leading){
            
            //edit field with bind value from data list
            TextField("Person Name ", text: $newTitleValue)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onAppear{
                    self.newTitleValue = self.data.title
            }
            
            //HStack button update and go home
            HStack{
                //Update button
                Button(action: {
                    self.datam.items[self.index].title = self.newTitleValue
                }){
                    Text("Update")
                }
                .padding()
                .background(Color.green)
                .cornerRadius(5)
                .foregroundColor(.white)
                
                //go home button link
                NavigationLink(destination: Home()){
                    Text("Home")
                }
                .padding()
                .background(Color.blue)
                .cornerRadius(5)
                .foregroundColor(.white)
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .navigationBarTitle("Detail")
    }
}

