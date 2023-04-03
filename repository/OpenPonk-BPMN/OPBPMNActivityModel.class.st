Class {
	#name : #OPBPMNActivityModel,
	#superclass : #OPBPMNFlowNodeModel,
	#instVars : [
		'isCallActivity'
	],
	#category : #'OpenPonk-BPMN-Models'
}

{ #category : #printing }
OPBPMNActivityModel >> defaultType [
	^ OPBPMNNodeType None
]

{ #category : #printing }
OPBPMNActivityModel >> initialize [ 
	super initialize.
	isCallActivity := false.
]

{ #category : #printing }
OPBPMNActivityModel >> isCallActivity [
	^ isCallActivity
]

{ #category : #printing }
OPBPMNActivityModel >> isCallActivity: aActivity [
	isCallActivity := aActivity
]

{ #category : #printing }
OPBPMNActivityModel >> printType [
	type = OPBPMNNodeType Service
		ifTrue: [ ^ 'serviceTask' ].
	type = OPBPMNNodeType User
		ifTrue: [ ^ 'userTask' ].
	type = OPBPMNNodeType Manual
		ifTrue: [ ^ 'manualTask' ].
	type = OPBPMNNodeType Send
		ifTrue: [ ^ 'sendTask' ].
	type = OPBPMNNodeType Receive
		ifTrue: [ ^ 'receiveTask'].
	type = OPBPMNNodeType None
		ifTrue: [ ^ 'task' ]
]
