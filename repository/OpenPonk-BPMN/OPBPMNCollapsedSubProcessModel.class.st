"
I represent a collapsed BPMN SubProcess in the semantic model, tracking execution properties while indicating its internal flow remains visually hidden.
"
Class {
	#name : 'OPBPMNCollapsedSubProcessModel',
	#superclass : 'OPBPMNFlowNodeModel',
	#instVars : [
		'isCallActivity'
	],
	#category : 'OpenPonk-BPMN-Models',
	#package : 'OpenPonk-BPMN',
	#tag : 'Models'
}

{ #category : 'initialization' }
OPBPMNCollapsedSubProcessModel >> initialize [ 
	super initialize.
	isCallActivity := false.
]

{ #category : 'accessing' }
OPBPMNCollapsedSubProcessModel >> isCallActivity [
	^ isCallActivity
]

{ #category : 'accessing' }
OPBPMNCollapsedSubProcessModel >> isCallActivity: aActivity [
	isCallActivity := aActivity
]

{ #category : 'printing' }
OPBPMNCollapsedSubProcessModel >> printType [

	self isCallActivity ifTrue: [ ^ 'callActivity' ].
	^ 'subProcess'
]
