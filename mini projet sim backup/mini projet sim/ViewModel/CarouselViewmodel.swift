//
//  CarouselViewmodel.swift
//  mini projet sim
//
//  Created by youssef benhissi on 02/01/2021.
//

import SwiftUI

class CarouselViewModel: ObservableObject {
    @Published var cardsRestaurantsDuJour = [

        CardRestaurantDuJour(cardColor: Color.blue, title: "Neurobics for your mind."),
        CardRestaurantDuJour(cardColor: Color.purple, title: "Brush up on hygine."),
        CardRestaurantDuJour(cardColor: Color.green, title: "Don't skip breakfast."),
        CardRestaurantDuJour(cardColor: Color.yellow, title: "Brush up on hygine."),
        CardRestaurantDuJour(cardColor: Color.orange, title: "Neurobics for your mind."),
        ]
    @Published var swipedCard = 0
    @Published var showCard = false
        @Published var selectedCard = CardRestaurantDuJour(cardColor: .clear, title: "")
        
        @Published var showContent = false
        
        var content = "Humans have long used cognitive enhancement methods to expand the proficiency and range of the various mental activities that they engage in, including writing to store and retrieve information, and computers that allow them to perform myriad activities that are now commonplace in the internet age. Neuroenhancement describes the use of neuroscience-based techniques for enhancing cognitive function by acting directly on the human brain and nervous system, altering its properties to increase performance. Cognitive neuroscience has now reached the point where it may begin to put theory derived from years of experimentation into practice. This special issue includes 16 articles that employ or examine a variety of neuroenhancement methods currently being developed to increase cognition in healthy people and in patients with neurological or psychiatric illness.This includes transcranial electromagnetic stimulation methods, such as transcranial direct current stimulation (tDCS) and transcranial magnetic stimulation (TMS), along with deep brain stimulation, neurofeedback, behavioral training techniques, and these and other techniques in conjunction with neuroimaging."

}

