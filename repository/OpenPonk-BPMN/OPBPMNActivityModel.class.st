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

{ #category : #printing }
OPBPMNActivityModel >> typeIconFor: aType [
	aType = OPBPMNNodeType Service
		ifTrue: [ ^ OPBPMNIcon current activityService ].
	aType = OPBPMNNodeType User
		ifTrue: [ ^ OPBPMNIcon current activityUser ].
	aType = OPBPMNNodeType Manual
		ifTrue: [ ^ OPBPMNIcon current activityManual ].
			aType = OPBPMNNodeType Send
		ifTrue: [ ^ OPBPMNIcon current activitySend ].
			aType = OPBPMNNodeType Receive
		ifTrue: [ ^ OPBPMNIcon current activityReceive ].
			aType = OPBPMNNodeType None
		ifTrue: [ ^ OPBPMNIcon current activityNone ]
]
