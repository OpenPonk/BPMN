Class {
	#name : 'OPBPMNElementController',
	#superclass : 'OPBPMNNodeController',
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'private' }
OPBPMNElementController >> dependentElements [

	^ self model flows
]

{ #category : 'announcements' }
OPBPMNElementController >> internalSubscribeTo: aModel [

	super internalSubscribeTo: aModel.
	aModel weakWhen: OPBPMNPlaceTokensChanged send: #modelChanged to: self
]
