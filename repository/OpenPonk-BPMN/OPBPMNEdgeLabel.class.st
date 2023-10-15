Class {
	#name : #OPBPMNEdgeLabel,
	#superclass : #OPEdgeLabel,
	#category : #'OpenPonk-BPMN-DiagramElements'
}

{ #category : #'as yet unclassified' }
OPBPMNEdgeLabel >> defaultAnchorConstraintPosition [

	^ OPRSAnchorConstraintBalanceReference balance: 0.4
]

{ #category : #'as yet unclassified' }
OPBPMNEdgeLabel >> defaultBalance [

	^ 0.4
]

{ #category : #'as yet unclassified' }
OPBPMNEdgeLabel >> defaultMinDistance [

	^ 5
]

{ #category : #accessing }
OPBPMNEdgeLabel >> defaultText [
	self modelElement name ifNil: [ ^'' ].
	^ self modelElement name
]

{ #category : #'as yet unclassified' }
OPBPMNEdgeLabel >> text [
	^ self modelElement name
]