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

	^ timerType ifNil: [ #none ]
]

{ #category : 'printing' }
OPBPMNEventModel >> timerType: aType [

	timerType := aType
]

{ #category : 'printing' }
OPBPMNEventModel >> timerValue [

	^ timerValue ifNil: [ '' ]
]

{ #category : 'printing' }
OPBPMNEventModel >> timerValue: aValue [
	timerValue := aValue

]
