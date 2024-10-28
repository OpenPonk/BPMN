Class {
	#name : 'OPBPMNElementController',
	#superclass : 'OPBPMNNodeController',
	#instVars : [
		'owner'
	],
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'private' }
OPBPMNElementController >> dependentElements [
	^ model flows
]

{ #category : 'announcements' }
OPBPMNElementController >> internalSubscribeTo: aModel [

	super internalSubscribeTo: aModel.
	aModel weakWhen: OPBPMNPlaceTokensChanged send: #modelChanged to: self
]
