"
Unit tests verifying default geometry, label wrapping, vertical label offsets, and vector icon dimensions for BPMN node shapes.
"
Class {
	#name : 'OPBPMNNodeShapeTest',
	#superclass : 'TestCase',
	#instVars : [
		'canvas'
	],
	#category : 'OpenPonk-BPMN-Tests-DiagramElements',
	#package : 'OpenPonk-BPMN-Tests',
	#tag : 'DiagramElements'
}

{ #category : 'running' }
OPBPMNNodeShapeTest >> setUp [

	super setUp.
	canvas := RSCanvas new
]

{ #category : 'running' }
OPBPMNNodeShapeTest >> tearDown [

	canvas := nil.
	super tearDown
]

{ #category : 'tests - labels' }
OPBPMNNodeShapeTest >> testActivityLabelWrapsWithinShapeWidthAndOffsetsBelowTypeIcon [

	| activityModel activityShape labeled labelShape |
	activityModel := OPBPMNActivityModel new
		                 name: 'Order from Vendor';
		                 type: OPBPMNNodeType None;
		                 yourself.
	activityShape := OPBPMNActivityShape new.
	activityShape modelElement: activityModel.
	activityShape renderIn: canvas.
	activityShape updateRenderFromModel.

	labeled := activityShape instVarNamed: #labeled.
	labelShape := labeled labelShape.
	self assert: activityShape wrapMaxWidth equals: activityShape width - (activityShape textPadding * 2).
	self assert: labelShape width <= activityShape wrapMaxWidth description: 'Wrapped activity label must fit within wrapMaxWidth'.
	self assert: labelShape position y closeTo: activityShape roassalShape position y precision: 1.0.

	activityModel type: OPBPMNNodeType Service.
	activityShape updateRenderFromModel.
	labelShape := labeled labelShape.
	self assert: labelShape position y closeTo: activityShape roassalShape position y + 6 precision: 1.0
]

{ #category : 'tests - geometry' }
OPBPMNNodeShapeTest >> testActivityShapeDefaultExtentAndBorderWidth [

	| activityShape |
	activityShape := OPBPMNActivityShape new.
	activityShape modelElement: (OPBPMNActivityModel new
			 name: 'Task';
			 yourself).
	activityShape renderIn: canvas.
	self assert: activityShape roassalShape baseRectangle extent equals: 110 @ 70.
	self assert: activityShape roassalShape border width equals: 1
]

{ #category : 'tests - labels' }
OPBPMNNodeShapeTest >> testCollapsedSubProcessLabelWrapsAndOffsetsAboveBottomMarkers [

	| subProcessModel collapsedShape labeled labelShape |
	subProcessModel := OPBPMNCollapsedSubProcessModel new
		                   name: 'Prepare Shipment';
		                   type: OPBPMNNodeType MarkerParallel;
		                   yourself.
	collapsedShape := OPBPMNCollapsedSubProcessShape new.
	collapsedShape modelElement: subProcessModel.
	collapsedShape renderIn: canvas.
	collapsedShape updateRenderFromModel.

	labeled := collapsedShape instVarNamed: #labeled.
	labelShape := labeled labelShape.
	self assert: collapsedShape wrapMaxWidth equals: collapsedShape width - (collapsedShape textPadding * 2).
	self
		assert: labelShape width <= collapsedShape wrapMaxWidth
		description: 'Wrapped collapsed subprocess label must fit within wrapMaxWidth'.
	self assert: labelShape position y closeTo: collapsedShape roassalShape position y - 7 precision: 1.0
]

{ #category : 'tests - geometry' }
OPBPMNNodeShapeTest >> testCollapsedSubProcessShapeDefaultExtentAndBorderWidth [

	| collapsedShape |
	collapsedShape := OPBPMNCollapsedSubProcessShape new.
	collapsedShape modelElement: (OPBPMNCollapsedSubProcessModel new
			 name: 'Sub';
			 yourself).
	collapsedShape renderIn: canvas.
	self assert: collapsedShape roassalShape baseRectangle extent equals: 110 @ 70.
	self assert: collapsedShape roassalShape border width equals: 1
]

{ #category : 'tests - geometry' }
OPBPMNNodeShapeTest >> testEventShapesDefaultDimensionsAndInnerCircles [

	| startShape intermediateShape boundaryShape endShape |
	startShape := OPBPMNStartEventShape new.
	startShape modelElement: (OPBPMNStartEventModel new
			 name: 'Start';
			 yourself).
	startShape renderIn: canvas.
	self assert: startShape roassalShape baseRectangle extent equals: 44 @ 44.

	intermediateShape := OPBPMNIntermediateEventShape new.
	intermediateShape modelElement: (OPBPMNIntermediateEventModel new
			 name: 'Mid';
			 yourself).
	intermediateShape renderIn: canvas.
	self assert: intermediateShape roassalShape baseRectangle extent equals: 44 @ 44.
	self assert: (intermediateShape instVarNamed: #innerCircle) baseRectangle extent equals: 36 @ 36.

	boundaryShape := OPBPMNBoundaryEventShape new.
	boundaryShape modelElement: (OPBPMNBoundaryEventModel new
			 name: 'Bound';
			 yourself).
	boundaryShape renderIn: canvas.
	self assert: boundaryShape roassalShape baseRectangle extent equals: 44 @ 44.
	self assert: (boundaryShape instVarNamed: #innerCircle) baseRectangle extent equals: 36 @ 36.

	endShape := OPBPMNEndEventShape new.
	endShape modelElement: (OPBPMNEndEventModel new
			 name: 'End';
			 yourself).
	endShape renderIn: canvas.
	self assert: endShape roassalShape baseRectangle extent equals: 40 @ 40.
	self assert: endShape roassalShape border width equals: 5
]

{ #category : 'tests - geometry' }
OPBPMNNodeShapeTest >> testGatewayDataObjectAnnotationAndPoolDefaultDimensions [

	| gatewayShape dataObjectShape annotationShape poolShape |
	gatewayShape := OPBPMNGatewayShape new.
	gatewayShape modelElement: (OPBPMNGatewayModel new
			 name: 'GW';
			 yourself).
	gatewayShape renderIn: canvas.
	self assert: gatewayShape roassalShape baseRectangle extent equals: 52 @ 52.

	dataObjectShape := OPBPMNDataObjectShape new.
	dataObjectShape modelElement: (OPBPMNDataObjectModel new
			 name: 'Data';
			 yourself).
	dataObjectShape renderIn: canvas.
	self assert: dataObjectShape roassalShape shapes first baseRectangle extent equals: 55 @ 55.

	annotationShape := OPBPMNAnnotationShape new.
	self assert: annotationShape visibleBorderWidth equals: 20.
	self assert: annotationShape minExtent equals: 22 @ 38.

	poolShape := OPBPMNPoolShape new.
	poolShape modelElement: (OPBPMNPoolModel new
			 name: 'Pool';
			 yourself).
	poolShape renderIn: canvas.
	self assert: poolShape roassalShape baseRectangle extent equals: 650 @ 200.
	poolShape adaptBoundsToInnerBounds: (Rectangle center: 0 @ 0 extent: 0 @ 0).
	self assert: poolShape roassalShape extent equals: 650 @ 200
]

{ #category : 'tests - geometry' }
OPBPMNNodeShapeTest >> testRoassalIconsAreScaledByTenPercentWithUnchangedBorderWidths [

	| userIcon manualIcon serviceIcon sendIcon timerIcon terminateIcon gatewayInclusiveIcon gatewayEventIcon subProcessMarker dataObjectIcon dataStoreIcon |
	userIcon := OPBPMNRoassalIconFactory activityUser.
	self assert: userIcon shapes first baseRectangle extent equals: 18 @ 18.
	self assert: userIcon shapes second border width closeTo: 1.2.

	manualIcon := OPBPMNRoassalIconFactory activityManual.
	self assert: manualIcon shapes first baseRectangle extent equals: 22 @ 18.
	self assert: manualIcon shapes second border width closeTo: 1.2.

	serviceIcon := OPBPMNRoassalIconFactory activityService.
	self assert: serviceIcon shapes first baseRectangle extent equals: 18 @ 18.

	sendIcon := OPBPMNRoassalIconFactory activitySend.
	self assert: sendIcon shapes first baseRectangle extent equals: 22 @ 15.

	timerIcon := OPBPMNRoassalIconFactory eventTimer.
	self assert: timerIcon shapes first baseRectangle extent equals: 20 @ 20.

	terminateIcon := OPBPMNRoassalIconFactory eventTerminate.
	self assert: terminateIcon shapes first baseRectangle extent equals: 22 @ 22.

	gatewayInclusiveIcon := OPBPMNRoassalIconFactory gatewayInclusive.
	self assert: gatewayInclusiveIcon shapes first baseRectangle extent equals: 22 @ 22.
	self assert: gatewayInclusiveIcon shapes second border width closeTo: 2.5.

	gatewayEventIcon := OPBPMNRoassalIconFactory gatewayEvent.
	self assert: gatewayEventIcon shapes first baseRectangle extent equals: 26 @ 26.

	subProcessMarker := OPBPMNRoassalIconFactory markerSubProcess.
	self assert: subProcessMarker shapes first baseRectangle extent equals: 16 @ 16.

	dataObjectIcon := OPBPMNRoassalIconFactory
		                  dataObjectIconForType: OPBPMNNodeType DataObject
		                  fillColor: Color white
		                  borderColor: Color black.
	self assert: dataObjectIcon shapes first baseRectangle extent equals: 44 @ 55.

	dataStoreIcon := OPBPMNRoassalIconFactory
		                 dataObjectIconForType: OPBPMNNodeType DataStore
		                 fillColor: Color white
		                 borderColor: Color black.
	self assert: dataStoreIcon shapes first baseRectangle extent equals: 55 @ 55
]

{ #category : 'tests - labels' }
OPBPMNNodeShapeTest >> testSubProcessLabelWrapsInsideTopAndRewrapsOnResize [

	| subProcessModel subProcessShape labeled initialWidth narrowLabelWidth |
	subProcessModel := OPBPMNSubProcessModel new
		                   name: 'Very Long Expanded SubProcess Title That Must Wrap';
		                   type: OPBPMNNodeType None;
		                   yourself.
	subProcessShape := OPBPMNSubProcessShape new.
	subProcessShape modelElement: subProcessModel.
	subProcessShape renderIn: canvas.
	subProcessShape updateRenderFromModel.

	labeled := subProcessShape instVarNamed: #labeled.
	initialWidth := labeled labelShape width.
	self assert: subProcessShape wrapMaxWidth equals: subProcessShape width - (subProcessShape textPadding * 2).
	self assert: initialWidth <= subProcessShape wrapMaxWidth description: 'SubProcess label must fit inside wrapMaxWidth'.
	self
		assert: labeled labelShape encompassingRectangle top > subProcessShape roassalShape encompassingRectangle top
		description: 'SubProcess label must remain inside the top border of the subprocess'.

	subProcessShape roassalShape extent: 120 @ 125.
	narrowLabelWidth := labeled labelShape width.
	self assert: subProcessShape wrapMaxWidth equals: subProcessShape width - (subProcessShape textPadding * 2).
	self assert: narrowLabelWidth <= subProcessShape wrapMaxWidth description: 'SubProcess label must re-wrap when resized narrower'
]

{ #category : 'tests - geometry' }
OPBPMNNodeShapeTest >> testSubProcessShapeDefaultExtentAndMinimumAdaptedExtent [

	| subProcessShape |
	subProcessShape := OPBPMNSubProcessShape new.
	subProcessShape modelElement: (OPBPMNSubProcessModel new
			 name: 'Sub';
			 yourself).
	subProcessShape renderIn: canvas.
	self assert: subProcessShape roassalShape baseRectangle extent equals: 190 @ 125.
	subProcessShape adaptBoundsToInnerBounds: (Rectangle center: 0 @ 0 extent: 50 @ 30).
	self assert: subProcessShape roassalShape extent equals: 250 @ 150
]
