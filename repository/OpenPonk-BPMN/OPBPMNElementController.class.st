Class {
	#name : 'OPBPMNElementController',
	#superclass : 'OPBPMNSemanticNodeController',
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'announcements' }
OPBPMNElementController >> internalSubscribeTo: aModel [

	super internalSubscribeTo: aModel.
	aModel weakWhen: OPBPMNPlaceTokensChanged send: #modelChanged to: self
]
