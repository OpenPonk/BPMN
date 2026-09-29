"
I am a specialized edge label for BPMN flows and associations. I calculate layout balance, constraints, and minimum distances for text placed along edges.
"
Class {
	#name : 'OPBPMNEdgeLabel',
	#superclass : 'OPEdgeLabel',
	#category : 'OpenPonk-BPMN-DiagramElements',
	#package : 'OpenPonk-BPMN',
	#tag : 'DiagramElements'
}

{ #category : 'adding' }
OPBPMNEdgeLabel >> defaultAnchorConstraintPosition [

	^ OPRSAnchorConstraintBalanceReference balance: 0.4
]

{ #category : 'accessing' }
OPBPMNEdgeLabel >> defaultBalance [

	^ 0.4
]

{ #category : 'adding' }
OPBPMNEdgeLabel >> defaultMinDistance [

	^ 5
]

{ #category : 'accessing' }
OPBPMNEdgeLabel >> defaultText [

	^ self modelElement name ifNil: [ ^ '' ] ifNotNil: [ :name | name ]
]

{ #category : 'accessing' }
OPBPMNEdgeLabel >> text [

	^ self modelElement name
]
