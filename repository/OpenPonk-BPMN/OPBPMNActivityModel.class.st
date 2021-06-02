Class {
	#name : #OPBPMNActivityModel,
	#superclass : #OPBPMNNodeModel,
	#category : #'OpenPonk-BPMN-Models'
}

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
