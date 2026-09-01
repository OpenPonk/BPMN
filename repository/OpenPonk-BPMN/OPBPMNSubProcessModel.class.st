"
I represent an expanded BPMN SubProcess in the semantic model. I act as a flow node that also functions as a container managing nested inner nodes and flows.
"
Class {
	#name : 'OPBPMNSubProcessModel',
	#superclass : 'OPBPMNFlowNodeModel',
	#category : 'OpenPonk-BPMN-Models',
	#package : 'OpenPonk-BPMN',
	#tag : 'Models'
}

{ #category : 'accessing' }
OPBPMNSubProcessModel >> @ aName [

	^ self nodeNamed: aName
]

{ #category : 'updating' }
OPBPMNSubProcessModel >> changed [

	super changed.
	owner changed
]

{ #category : 'accessing' }
OPBPMNSubProcessModel >> nodeNamed: aName [

	^ self elementNamed: aName
]

{ #category : 'printing' }
OPBPMNSubProcessModel >> printType [

	^ 'subprocess'
]

{ #category : 'removing' }
OPBPMNSubProcessModel >> removeAllNodes [

	self removeAll
]

{ #category : 'removing' }
OPBPMNSubProcessModel >> removeNode: aNode [

	elements remove: aNode
]
