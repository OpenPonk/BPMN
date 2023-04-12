Class {
	#name : #OPBPMNCollapsedSubProcessModel,
	#superclass : #OPBPMNFlowNodeModel,
	#instVars : [
		'isCallActivity'
	],
	#category : #'OpenPonk-BPMN-Models'
}

{ #category : #accessing }
OPBPMNCollapsedSubProcessModel >> defaultType [
	^ OPBPMNNodeType None
]

{ #category : #accessing }
OPBPMNCollapsedSubProcessModel >> initialize [ 
	super initialize.
	isCallActivity := false.
]

{ #category : #accessing }
OPBPMNCollapsedSubProcessModel >> isCallActivity [
	^ isCallActivity
]

{ #category : #accessing }
OPBPMNCollapsedSubProcessModel >> isCallActivity: aActivity [
	isCallActivity := aActivity
]

{ #category : #accessing }
OPBPMNCollapsedSubProcessModel >> printType [
	type = OPBPMNNodeType MarkerParallel 
		ifTrue: [ ^ 'MarkerParallel' ].
	type = OPBPMNNodeType MarkerSequential 
		ifTrue: [ ^ 'MarkerSequential' ].
	type = OPBPMNNodeType MarkerAdhoc 
		ifTrue: [ ^ 'MarkerAdhoc' ].
	type = OPBPMNNodeType MarkerCompensation 
		ifTrue: [ ^ 'MarkerCompensation' ].
	type = OPBPMNNodeType MarkerLoop 
		ifTrue: [ ^ 'MarkerLoop']
]

{ #category : #accessing }
OPBPMNCollapsedSubProcessModel >> typeIconFor: aType [
	aType = OPBPMNNodeType None 
		ifTrue: [ ^ OPBPMNIcon current activityNone ].
	aType = OPBPMNNodeType MarkerParallel 
		ifTrue: [ ^ OPBPMNIcon current markerParallel ].
	aType = OPBPMNNodeType MarkerSequential 
		ifTrue: [ ^ OPBPMNIcon current markerSequential ].
	aType = OPBPMNNodeType MarkerLoop
		ifTrue: [ ^ OPBPMNIcon current markerLoop ].
	aType = OPBPMNNodeType MarkerCompensation 
		ifTrue: [ ^ OPBPMNIcon current markerCompensation ].
	aType = OPBPMNNodeType MarkerAdhoc 
		ifTrue: [ ^ OPBPMNIcon current markerAdhoc ]
]
