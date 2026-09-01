"
I represent a BPMN Event in the semantic model. I manage event-specific execution configurations, such as timer triggers and values.
"
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

{ #category : 'accessing' }
OPBPMNEventModel >> timerType [

	^ timerType ifNil: [ #none ]
]

{ #category : 'accessing' }
OPBPMNEventModel >> timerType: aType [

	timerType := aType
]

{ #category : 'accessing' }
OPBPMNEventModel >> timerValue [

	^ timerValue ifNil: [ '' ]
]

{ #category : 'accessing' }
OPBPMNEventModel >> timerValue: aValue [
	timerValue := aValue

]
