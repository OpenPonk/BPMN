"
I am a general controller for BPMN elements, providing common subscriptions and UI updates linking the semantic model to the diagram views.
"
Class {
	#name : 'OPBPMNElementController',
	#superclass : 'OPBPMNSemanticNodeController',
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'announcements' }
OPBPMNElementController >> subscribeToViewModel [

	super subscribeToViewModel.
	self viewModel announcer weak
		when: OPBPMNPlaceTokensChanged
		send: #modelChanged
		to: self
]
