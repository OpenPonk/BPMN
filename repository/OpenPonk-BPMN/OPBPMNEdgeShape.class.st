Class {
	#name : #OPBPMNEdgeShape,
	#superclass : #OPEdge,
	#category : #'OpenPonk-BPMN-Shapes'
}

{ #category : #'as yet unclassified' }
OPBPMNEdgeShape >> createOwnedElementsWithoutController [

	super createOwnedElementsWithoutController.
	self ownedElements
		detect: [ :any | any isKindOf: OPBPMNEdgeLabel ]
		ifFound: [ ^ self ].
	OPBPMNEdgeLabel in: self
]
