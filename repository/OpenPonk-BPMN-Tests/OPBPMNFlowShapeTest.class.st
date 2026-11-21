"
Tests sequence and message flow shape rendering, markers, and line segments in BPMN diagrams.
"
Class {
	#name : 'OPBPMNFlowShapeTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-BPMN-Tests-DiagramElements',
	#package : 'OpenPonk-BPMN-Tests',
	#tag : 'DiagramElements'
}

{ #category : 'tests' }
OPBPMNFlowShapeTest >> testAssociationShapeColorMarkerAndAnnotationRemovalUnsubscribesFromEdge [

	| canvas sourceShape targetShape flowShape annotationShape associationShape marker subscriptionsBefore subscriptionsAfter |
	canvas := RSCanvas new.
	associationShape := OPBPMNAssociationShape new.
	self assert: (associationShape colorMarker: nil) identicalTo: nil.
	marker := OPRSMarkerBuilder arrow.
	self assert: (associationShape colorMarker: marker) identicalTo: marker.

	sourceShape := OPBPMNActivityShape new
		               modelElement: (OPBPMNActivityModel new
				                name: 'Task A';
				                yourself);
		               renderIn: canvas;
		               yourself.
	targetShape := OPBPMNActivityShape new
		               modelElement: (OPBPMNActivityModel new
				                name: 'Task B';
				                yourself);
		               renderIn: canvas;
		               yourself.
	flowShape := OPBPMNFlowShape new
		             modelElement: (OPBPMNFlowModel new
				              type: 'Normal';
				              yourself);
		             source: sourceShape;
		             target: targetShape;
		             renderIn: canvas;
		             yourself.
	annotationShape := OPBPMNAnnotationShape new
		                   modelElement: (OPBPMNAnnotationModel new
				                    text: 'Note';
				                    yourself);
		                   renderIn: canvas;
		                   yourself.
	associationShape
		modelElement: OPBPMNAssociationModel new;
		source: annotationShape;
		target: sourceShape;
		renderIn: canvas.
	flowShape associationCreated: associationShape.

	associationShape roassalShape color: Color blue.
	associationShape colorMarker: marker.
	self assert: marker shape color equals: Color blue.

	subscriptionsBefore := associationShape roassalShape announcer subscriptions subscriptions count: [ :eachSubscription |
		                       eachSubscription subscriber == annotationShape ].
	self
		assert: subscriptionsBefore > 0
		description: 'Annotation shape must subscribe to connected association roassalShape announcer'.

	annotationShape removeRender.
	subscriptionsAfter := associationShape roassalShape announcer subscriptions subscriptions count: [ :eachSubscription |
		                      eachSubscription subscriber == annotationShape ].
	self assert: subscriptionsAfter equals: 0
]

{ #category : 'tests' }
OPBPMNFlowShapeTest >> testCreateOwnedElementsWithoutControllerIsIdempotent [

	| flowShapes |
	flowShapes := {
		              OPBPMNFlowShape new.
		              OPBPMNDataFlowShape new.
		              OPBPMNMessageFlowShape new }.
	flowShapes do: [ :eachFlowShape |
			| initialLabelsCount labelsCountAfterSecondCall |
			eachFlowShape createOwnedElementsWithoutController.
			initialLabelsCount := eachFlowShape ownedElements count: [ :eachOwnedElement | eachOwnedElement class == OPBPMNEdgeLabel ].

			self assert: initialLabelsCount equals: 1.

			eachFlowShape createOwnedElementsWithoutController.
			labelsCountAfterSecondCall := eachFlowShape ownedElements count: [ :eachOwnedElement |
				                              eachOwnedElement class == OPBPMNEdgeLabel ].

			self assert: labelsCountAfterSecondCall equals: 1 ]
]

{ #category : 'tests' }
OPBPMNFlowShapeTest >> testEdgeLabelDefaultTextHandlesNilAndNamedModel [

	| flowModel edgeLabel |
	flowModel := OPBPMNFlowModel new
		             name: nil;
		             yourself.
	edgeLabel := OPBPMNEdgeLabel new
		             modelElement: flowModel;
		             yourself.
	self assert: edgeLabel defaultText equals: ''.

	flowModel name: 'Approved'.
	self assert: edgeLabel defaultText equals: 'Approved'
]

{ #category : 'tests' }
OPBPMNFlowShapeTest >> testFlowShapesStrokeColorAndBorderColorBeforeAndAfterRender [

	| canvas sourceShape targetShape |
	canvas := RSCanvas new.
	sourceShape := OPBPMNActivityShape new
		               modelElement: (OPBPMNActivityModel new
				                name: 'Task';
				                yourself);
		               renderIn: canvas;
		               yourself.
	targetShape := OPBPMNDataObjectShape new
		               modelElement: (OPBPMNDataObjectModel new
				                name: 'Data';
				                yourself);
		               renderIn: canvas;
		               yourself.

	{
		(OPBPMNFlowShape new
			 modelElement: (OPBPMNFlowModel new
					  type: 'Normal';
					  yourself);
			 yourself).
		(OPBPMNMessageFlowShape new
			 modelElement: OPBPMNMessageFlowModel new;
			 yourself).
		(OPBPMNDataFlowShape new
			 modelElement: OPBPMNDataFlowModel new;
			 yourself) } do: [ :eachFlowShape |
			self assert: eachFlowShape borderColor equals: Color black.
			eachFlowShape strokeColor: Color red.
			self assert: eachFlowShape borderColor equals: Color black.

			eachFlowShape
				source: sourceShape;
				target: targetShape;
				renderIn: canvas.
			self assert: eachFlowShape borderColor equals: Color black.
			eachFlowShape strokeColor: Color red.
			self assert: eachFlowShape roassalShape color equals: Color red.
			self assert: eachFlowShape borderColor equals: Color red ]
]

{ #category : 'tests' }
OPBPMNFlowShapeTest >> testSequenceFlowRendersHeadAndTailMarkers [

	| canvas sourceShape targetShape flowModel flowShape |
	canvas := RSCanvas new.
	sourceShape := OPBPMNStartEventShape new
		               modelElement: (OPBPMNStartEventModel new
				                name: 'Start';
				                yourself);
		               renderIn: canvas;
		               yourself.
	targetShape := OPBPMNEndEventShape new
		               modelElement: (OPBPMNEndEventModel new
				                name: 'End';
				                yourself);
		               renderIn: canvas;
		               yourself.
	flowModel := OPBPMNFlowModel new
		             type: 'Normal';
		             yourself.
	flowShape := OPBPMNFlowShape new
		             modelElement: flowModel;
		             source: sourceShape;
		             target: targetShape;
		             renderIn: canvas;
		             yourself.

	self assert: flowShape roassalShape markerStart class identicalTo: RSMarker.
	self assert: flowShape roassalShape markerEnd class identicalTo: RSMarker.
	self assert: flowShape roassalShape markerEnd shape color equals: Color black
]

{ #category : 'tests' }
OPBPMNFlowShapeTest >> testSequenceFlowTailMarkerHandlesNilModelAndAllFlowTypes [

	| flowShape nilMarker normalMarker conditionalMarker defaultMarker |
	flowShape := OPBPMNFlowShape new.
	nilMarker := flowShape tailMarker.
	self assert: nilMarker points size equals: 1.
	self assert: nilMarker color equals: Color black.

	flowShape modelElement: (OPBPMNFlowModel new
			 type: 'Normal';
			 yourself).
	normalMarker := flowShape tailMarker.
	self assert: normalMarker points size equals: 1.

	flowShape modelElement type: 'Conditional'.
	conditionalMarker := flowShape tailMarker.
	self assert: conditionalMarker points size equals: 4.

	flowShape modelElement type: 'Default'.
	defaultMarker := flowShape tailMarker.
	self assert: defaultMarker points size equals: 4
]
