"
I represent a BPMN Activity in the semantic model. I track specific execution properties, such as whether the activity functions as a reusable call activity.
"
Class {
	#name : 'OPBPMNActivityModel',
	#superclass : 'OPBPMNFlowNodeModel',
	#instVars : [
		'isCallActivity'
	],
	#category : 'OpenPonk-BPMN-Models',
	#package : 'OpenPonk-BPMN',
	#tag : 'Models'
}

{ #category : 'initialization' }
OPBPMNActivityModel >> initialize [ 
	super initialize.
	isCallActivity := false.
]

{ #category : 'accessing' }
OPBPMNActivityModel >> isCallActivity [
	^ isCallActivity
]

{ #category : 'accessing' }
OPBPMNActivityModel >> isCallActivity: aActivity [
	isCallActivity := aActivity
]

{ #category : 'printing' }
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
