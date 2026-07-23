Class {
	#name : 'OPBPMNEventController',
	#superclass : 'OPBPMNElementController',
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'accessing' }
OPBPMNEventController >> modelClass [
	^ self subclassResponsibility
]

{ #category : 'hooks' }
OPBPMNEventController >> typeIconForModel [
	^ self model typeIconFor: self model type
]
