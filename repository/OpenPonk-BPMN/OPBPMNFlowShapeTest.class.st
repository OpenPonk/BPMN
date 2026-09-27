Class {
	#name : 'OPBPMNFlowShapeTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

{ #category : 'tests' }
OPBPMNFlowShapeTest >> testCreateOwnedElementsWithoutControllerIsIdempotent [
	| flowShapes |
	flowShapes := { OPBPMNFlowShape new . OPBPMNDataFlowShape new . OPBPMNMessageFlowShape new }.
	flowShapes do: [ :eachFlowShape |
		| initialLabelsCount labelsCountAfterSecondCall |
		eachFlowShape createOwnedElementsWithoutController.
		initialLabelsCount := (eachFlowShape ownedElements select: [ :eachOwnedElement |
			eachOwnedElement className = 'OPBPMNEdgeLabel' ]) size.

		self assert: initialLabelsCount equals: 1.

		eachFlowShape createOwnedElementsWithoutController.
		labelsCountAfterSecondCall := (eachFlowShape ownedElements select: [ :eachOwnedElement |
			eachOwnedElement className = 'OPBPMNEdgeLabel' ]) size.

		self assert: labelsCountAfterSecondCall equals: 1 ]
]
