Class {
	#name : 'OPBPMNEventModel',
	#superclass : 'OPBPMNFlowNodeModel',
	#instVars : [
		'timerType',
		'timerValue'
	],
	#category : 'OpenPonk-BPMN-Models',
	#package : 'OpenPonk-BPMN',
	#tag : 'Models'
}

{ #category : 'printing' }
OPBPMNEventModel >> timerType [
	^ timerType

]

{ #category : 'printing' }
OPBPMNEventModel >> timerType: aType [
	(aType = 'none')
		ifTrue: [ timerType := nil ]
		ifFalse: [ timerType := aType ]
]

{ #category : 'printing' }
OPBPMNEventModel >> timerValue [
	^ timerValue

]

{ #category : 'printing' }
OPBPMNEventModel >> timerValue: aValue [
	timerValue := aValue

]
