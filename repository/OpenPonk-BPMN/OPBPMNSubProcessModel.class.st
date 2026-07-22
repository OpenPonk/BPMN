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

{ #category : 'announcing' }
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
