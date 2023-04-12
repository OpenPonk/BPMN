Class {
	#name : #OPBPMNEventController,
	#superclass : #OPBPMNElementController,
	#instVars : [
		'iconElement',
		'iconConstraint'
	],
	#category : #'OpenPonk-BPMN-Controllers'
}

{ #category : #accessing }
OPBPMNEventController >> modelClass [
	^ self subclassResponsibility
]

{ #category : #hooks }
OPBPMNEventController >> typeIconForModel [
	^ self model typeIconFor: self model type
]
