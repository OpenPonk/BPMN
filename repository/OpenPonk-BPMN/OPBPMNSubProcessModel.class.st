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

{ #category : 'accessing' }
OPBPMNSubProcessModel >> changed [

	super changed.
	owner changed
]

{ #category : 'accessing' }
OPBPMNSubProcessModel >> nodeNamed: aName [

	^ self elementNamed: aName
]

{ #category : 'accessing' }
OPBPMNSubProcessModel >> nodes [

	^ elements
]

{ #category : 'accessing' }
OPBPMNSubProcessModel >> printType [

	^ 'subprocess'
]

{ #category : 'accessing' }
OPBPMNSubProcessModel >> removeAllNodes [

	self removeAll
]

{ #category : 'accessing' }
OPBPMNSubProcessModel >> removeNode: aNode [

	elements remove: aNode
]
