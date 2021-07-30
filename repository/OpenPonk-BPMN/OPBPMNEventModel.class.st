Class {
	#name : #OPBPMNEventModel,
	#superclass : #OPBPMNNodeModel,
	#instVars : [
		'timerType',
		'timerValue'
	],
	#category : #'OpenPonk-BPMN-Models'
}

{ #category : #printing }
OPBPMNEventModel >> timerType [
	^ timerType

]

{ #category : #printing }
OPBPMNEventModel >> timerType: aType [
	(aType = 'none')
		ifTrue: [ timerType := nil ]
		ifFalse: [ timerType := aType ]
]

{ #category : #printing }
OPBPMNEventModel >> timerValue [
	^ timerValue

]

{ #category : #printing }
OPBPMNEventModel >> timerValue: aValue [
	timerValue := aValue

]
