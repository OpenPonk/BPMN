"
Builds pure vector Roassal 3 composite shapes for BPMN node markers, activity types, event triggers, gateway symbols, and data object figures without using raster bitmaps.
"
Class {
	#name : 'OPBPMNRoassalIconFactory',
	#superclass : 'Object',
	#category : 'OpenPonk-BPMN-DiagramElements',
	#package : 'OpenPonk-BPMN',
	#tag : 'DiagramElements'
}

{ #category : 'dispatching' }
OPBPMNRoassalIconFactory class >> activityIconForType: aType [
	aType = OPBPMNNodeType None ifTrue: [ ^ self emptyIcon ].
	aType = OPBPMNNodeType Service ifTrue: [ ^ self activityService ].
	aType = OPBPMNNodeType User ifTrue: [ ^ self activityUser ].
	aType = OPBPMNNodeType Manual ifTrue: [ ^ self activityManual ].
	aType = OPBPMNNodeType Send ifTrue: [ ^ self activitySend ].
	aType = OPBPMNNodeType Receive ifTrue: [ ^ self activityReceive ].
	^ OPBPMNUnknownNodeTypeError signalForType: aType
]

{ #category : 'building - activity' }
OPBPMNRoassalIconFactory class >> activityManual [

	| border palm f1 f2 f3 |
	border := self blackBorderWidth: 1.2.
	palm := RSPolygon new
		        points: {
				        (-8.8 @ 5.7).
				        (-8.8 @ -0.9).
				        (-4.6 @ -5.0).
				        (-1.7 @ -6.0).
				        (-0.9 @ -4.6).
				        (-3.1 @ -2.2).
				        (7.7 @ -2.2).
				        (8.6 @ -1.1).
				        (8.6 @ 4.6).
				        (7.5 @ 5.7) };
		        color: Color white;
		        border: border;
		        yourself.
	f1 := RSLine new
		      startPoint: 0.6 @ -0.2;
		      endPoint: 8.4 @ -0.2;
		      border: (self blackBorderWidth: 1.0);
		      yourself.
	f2 := RSLine new
		      startPoint: 0.6 @ 1.8;
		      endPoint: 8.4 @ 1.8;
		      border: (self blackBorderWidth: 1.0);
		      yourself.
	f3 := RSLine new
		      startPoint: 0.6 @ 3.7;
		      endPoint: 8.4 @ 3.7;
		      border: (self blackBorderWidth: 1.0);
		      yourself.
	^ self
		  compositeWith: {
				  palm.
				  f1.
				  f2.
				  f3 }
		  extent: 22 @ 18
]

{ #category : 'building - activity' }
OPBPMNRoassalIconFactory class >> activityReceive [

	^ self envelopeWidth: 20 height: 13 filled: false
]

{ #category : 'building - event' }
OPBPMNRoassalIconFactory class >> activityReceiveSquare [

	^ self envelopeWidth: 15 height: 11 filled: false
]

{ #category : 'building - activity' }
OPBPMNRoassalIconFactory class >> activitySend [

	^ self envelopeWidth: 20 height: 13 filled: true
]

{ #category : 'building - event' }
OPBPMNRoassalIconFactory class >> activitySendSquare [

	^ self envelopeWidth: 15 height: 11 filled: true
]

{ #category : 'building - activity' }
OPBPMNRoassalIconFactory class >> activityService [

	| shapes |
	shapes := OrderedCollection new.
	shapes addAll: (self
			 gearAt: -2.4 @ -2.4
			 outerRadius: 5.7
			 innerRadius: 3.9
			 holeRadius: 1.7
			 teeth: 8).
	shapes addAll: (self
			 gearAt: 2.4 @ 2.4
			 outerRadius: 5.7
			 innerRadius: 3.9
			 holeRadius: 1.7
			 teeth: 8).
	^ self compositeWith: shapes extent: 18 @ 18
]

{ #category : 'building - activity' }
OPBPMNRoassalIconFactory class >> activityUser [

	| border body leftLine rightLine head hair |
	border := self blackBorderWidth: 1.2.
	body := RSPolygon new
		        points: {
				        (-7.2 @ 7.7).
				        (-7.2 @ 4.0).
				        (-5.1 @ 1.3).
				        (-2.4 @ 0.2).
				        (2.4 @ 0.2).
				        (5.1 @ 1.3).
				        (7.2 @ 4.0).
				        (7.2 @ 7.7) };
		        color: Color white;
		        border: border;
		        yourself.
	leftLine := RSLine new
		            startPoint: -4.0 @ 4.0;
		            endPoint: -4.0 @ 7.7;
		            border: (self blackBorderWidth: 1.0);
		            yourself.
	rightLine := RSLine new
		             startPoint: 4.0 @ 4.0;
		             endPoint: 4.0 @ 7.7;
		             border: (self blackBorderWidth: 1.0);
		             yourself.
	head := RSCircle new
		        position: 0 @ -3.6;
		        size: 7.3;
		        color: Color white;
		        border: border;
		        yourself.
	hair := RSPolygon new
		        points: {
				        (-3.4 @ -4.5).
				        (-2.0 @ -6.8).
				        (0 @ -7.3).
				        (2.0 @ -6.8).
				        (3.4 @ -4.5).
				        (0 @ -5.3) };
		        color: Color black;
		        border: nil;
		        yourself.
	^ self
		  compositeWith: {
				  body.
				  leftLine.
				  rightLine.
				  head.
				  hair }
		  extent: 18 @ 18
]

{ #category : 'building - common' }
OPBPMNRoassalIconFactory class >> blackBorderWidth: aNumber [
	^ RSBorder new
		color: Color black;
		width: aNumber;
		capRound;
		joinRound;
		yourself
]

{ #category : 'dispatching' }
OPBPMNRoassalIconFactory class >> boundaryEventIconForType: aType [
	aType = OPBPMNNodeType Receive ifTrue: [ ^ self activityReceiveSquare ].
	aType = OPBPMNNodeType Timer ifTrue: [ ^ self eventTimer ].
	aType = OPBPMNNodeType Escalation ifTrue: [ ^ self eventEscalation: false ].
	aType = OPBPMNNodeType Conditional ifTrue: [ ^ self eventCondition ].
	aType = OPBPMNNodeType Error ifTrue: [ ^ self eventError: false ].
	aType = OPBPMNNodeType Cancel ifTrue: [ ^ self eventCancel: false ].
	aType = OPBPMNNodeType Signal ifTrue: [ ^ self eventSignal: false ].
	aType = OPBPMNNodeType Multiple ifTrue: [ ^ self eventMultiple: false ].
	aType = OPBPMNNodeType ParallelMultiple ifTrue: [ ^ self eventParallelMultiple ].
	aType = OPBPMNNodeType CatchCompensation ifTrue: [ ^ self eventCompensation: false ].
	^ OPBPMNUnknownNodeTypeError signalForType: aType
]

{ #category : 'building - common' }
OPBPMNRoassalIconFactory class >> compositeWith: aShapeCollection extent: anExtentPoint [
	| composite boundingBox |
	composite := RSComposite new.
	boundingBox := RSBox new
		extent: anExtentPoint;
		color: Color transparent;
		border: nil;
		yourself.
	composite add: boundingBox.
	aShapeCollection do: [ :eachShape | composite add: eachShape ].
	composite adjustToChildren.
	^ composite
]

{ #category : 'dispatching' }
OPBPMNRoassalIconFactory class >> dataObjectIconForType: aType fillColor: aFillColor borderColor: aBorderColor [
	| resolvedFill resolvedBorder |
	resolvedFill := (aFillColor isNil or: [ aFillColor = Color transparent ])
		ifTrue: [ Color white ]
		ifFalse: [ aFillColor ].
	resolvedBorder := (aBorderColor isNil or: [ aBorderColor = Color transparent ])
		ifTrue: [ Color black ]
		ifFalse: [ aBorderColor ].
	aType = OPBPMNNodeType DataObject ifTrue: [
		^ self dataObjectPageWithArrow: nil fillColor: resolvedFill borderColor: resolvedBorder ].
	aType = OPBPMNNodeType DataInput ifTrue: [
		^ self dataObjectPageWithArrow: false fillColor: resolvedFill borderColor: resolvedBorder ].
	aType = OPBPMNNodeType DataOutput ifTrue: [
		^ self dataObjectPageWithArrow: true fillColor: resolvedFill borderColor: resolvedBorder ].
	aType = OPBPMNNodeType DataStore ifTrue: [
		^ self dataStoreWithFillColor: resolvedFill borderColor: resolvedBorder ].
	^ OPBPMNUnknownNodeTypeError signalForType: aType
]

{ #category : 'building - data object' }
OPBPMNRoassalIconFactory class >> dataObjectPageWithArrow: anArrowFilledBooleanOrNil fillColor: aFillColor borderColor: aBorderColor [

	| border page fold shapes arrow |
	border := RSBorder new
		          color: aBorderColor;
		          width: 1.8;
		          capRound;
		          joinRound;
		          yourself.
	page := RSPolygon new
		        points: {
				        (-20 @ -25).
				        (9 @ -25).
				        (20 @ -14).
				        (20 @ 25).
				        (-20 @ 25) };
		        color: aFillColor;
		        border: border;
		        yourself.
	fold := RSPolygon new
		        points: {
				        (9 @ -25).
				        (9 @ -14).
				        (20 @ -14) };
		        color: aFillColor;
		        border: border;
		        yourself.
	shapes := OrderedCollection with: page with: fold.
	anArrowFilledBooleanOrNil ifNotNil: [
			arrow := RSPolygon new
				         points: {
						         (-14.3 @ -17.0).
						         (-4.4 @ -17.0).
						         (-4.4 @ -20.9).
						         (3.3 @ -14.3).
						         (-4.4 @ -7.7).
						         (-4.4 @ -11.6).
						         (-14.3 @ -11.6) };
				         color: (anArrowFilledBooleanOrNil
						          ifTrue: [ aBorderColor ]
						          ifFalse: [ Color white ]);
				         border: (RSBorder new
						          color: aBorderColor;
						          width: 1.3;
						          yourself);
				         yourself.
			shapes add: arrow ].
	^ self compositeWith: shapes extent: 44 @ 55
]

{ #category : 'building - data object' }
OPBPMNRoassalIconFactory class >> dataStoreWithFillColor: aFillColor borderColor: aBorderColor [

	| border bottomArcPoints bodyPolygon topEllipse midArc1 midArc2 |
	border := RSBorder new
		          color: aBorderColor;
		          width: 1.8;
		          capRound;
		          joinRound;
		          yourself.
	bottomArcPoints := (0 to: 20) collect: [ :eachStep |
			                   | rad |
			                   rad := eachStep * Float pi / 20.0.
			                   rad cos * 24.2 @ (14.3 + (rad sin * 7.2)) ].
	bodyPolygon := RSPolygon new
		               points: { (-24.2 @ -15.4) } , bottomArcPoints reversed , { (24.2 @ -15.4) };
		               color: aFillColor;
		               border: border;
		               yourself.
	midArc2 := self
		           lowerCylinderArcAtY: -4.4
		           radiusX: 24.2
		           radiusY: 7.2
		           border: border.
	midArc1 := self
		           lowerCylinderArcAtY: -9.9
		           radiusX: 24.2
		           radiusY: 7.2
		           border: border.
	topEllipse := RSEllipse new
		              position: 0 @ -15.4;
		              extent: 48.4 @ 14.3;
		              color: aFillColor;
		              border: border;
		              yourself.
	^ self
		  compositeWith: {
				  bodyPolygon.
				  midArc2.
				  midArc1.
				  topEllipse }
		  extent: 55 @ 55
]

{ #category : 'building - common' }
OPBPMNRoassalIconFactory class >> emptyIcon [
	^ RSComposite new
]

{ #category : 'dispatching' }
OPBPMNRoassalIconFactory class >> endEventIconForType: aType [
	aType = OPBPMNNodeType None ifTrue: [ ^ self emptyIcon ].
	aType = OPBPMNNodeType Send ifTrue: [ ^ self activitySendSquare ].
	aType = OPBPMNNodeType EscalationThrow ifTrue: [ ^ self eventEscalation: true ].
	aType = OPBPMNNodeType Error ifTrue: [ ^ self eventError: true ].
	aType = OPBPMNNodeType Cancel ifTrue: [ ^ self eventCancel: true ].
	aType = OPBPMNNodeType CompensationThrow ifTrue: [ ^ self eventCompensation: true ].
	aType = OPBPMNNodeType SignalThrow ifTrue: [ ^ self eventSignal: true ].
	aType = OPBPMNNodeType MultipleThrow ifTrue: [ ^ self eventMultiple: true ].
	aType = OPBPMNNodeType Terminate ifTrue: [ ^ self eventTerminate ].
	^ OPBPMNUnknownNodeTypeError signalForType: aType
]

{ #category : 'building - common' }
OPBPMNRoassalIconFactory class >> envelopeWidth: aWidth height: aHeight filled: aBoolean [
	| halfW halfH box flap lineBorder |
	halfW := aWidth / 2.0.
	halfH := aHeight / 2.0.
	lineBorder := aBoolean
		ifTrue: [ self whiteBorderWidth: 1.3 ]
		ifFalse: [ self blackBorderWidth: 1.2 ].
	box := RSBox new
		extent: aWidth @ aHeight;
		color: (aBoolean ifTrue: [ Color black ] ifFalse: [ Color white ]);
		border: (self blackBorderWidth: 1.2);
		yourself.
	flap := RSPolyline new
		controlPoints: {
			halfW negated @ halfH negated .
			0 @ 1 .
			halfW @ halfH negated };
		border: lineBorder;
		yourself.
	^ self compositeWith: { box . flap } extent: (aWidth + 2) @ (aHeight + 2)
]

{ #category : 'building - event' }
OPBPMNRoassalIconFactory class >> eventCancel: aBoolean [

	| polygon |
	polygon := RSPolygon new
		           points: {
				           (-5.5 @ -7.7).
				           (0 @ -2.2).
				           (5.5 @ -7.7).
				           (7.7 @ -5.5).
				           (2.2 @ 0).
				           (7.7 @ 5.5).
				           (5.5 @ 7.7).
				           (0 @ 2.2).
				           (-5.5 @ 7.7).
				           (-7.7 @ 5.5).
				           (-2.2 @ 0).
				           (-7.7 @ -5.5) };
		           color: (aBoolean
				            ifTrue: [ Color black ]
				            ifFalse: [ Color white ]);
		           border: (self blackBorderWidth: 1.2);
		           yourself.
	^ self compositeWith: { polygon } extent: 18 @ 18
]

{ #category : 'building - event' }
OPBPMNRoassalIconFactory class >> eventCompensation: aBoolean [

	| fillColor border t1 t2 |
	fillColor := aBoolean
		             ifTrue: [ Color black ]
		             ifFalse: [ Color white ].
	border := self blackBorderWidth: 1.2.
	t1 := RSPolygon new
		      points: {
				      (-7.2 @ 0).
				      (-0.6 @ -5.5).
				      (-0.6 @ 5.5) };
		      color: fillColor;
		      border: border;
		      yourself.
	t2 := RSPolygon new
		      points: {
				      (-0.6 @ 0).
				      (6.0 @ -5.5).
				      (6.0 @ 5.5) };
		      color: fillColor;
		      border: border;
		      yourself.
	^ self
		  compositeWith: {
				  t1.
				  t2 }
		  extent: 18 @ 18
]

{ #category : 'building - event' }
OPBPMNRoassalIconFactory class >> eventCondition [

	| box lines |
	box := RSBox new
		       extent: 13 @ 16.5;
		       color: Color white;
		       border: (self blackBorderWidth: 1.2);
		       yourself.
	lines := #( -5.0 -1.7 1.7 5.0 ) collect: [ :eachY |
			         RSLine new
				         startPoint: -3.9 @ eachY;
				         endPoint: 3.9 @ eachY;
				         border: (self blackBorderWidth: 1.0);
				         yourself ].
	^ self compositeWith: { box } , lines extent: 18 @ 18
]

{ #category : 'building - event' }
OPBPMNRoassalIconFactory class >> eventError: aBoolean [

	| polygon |
	polygon := RSPolygon new
		           points: {
				           (-6.6 @ 7.2).
				           (-2.4 @ -6.4).
				           (2.4 @ 0.4).
				           (6.6 @ -7.2).
				           (2.4 @ 6.4).
				           (-2.4 @ -0.4) };
		           color: (aBoolean
				            ifTrue: [ Color black ]
				            ifFalse: [ Color white ]);
		           border: (self blackBorderWidth: 1.2);
		           yourself.
	^ self compositeWith: { polygon } extent: 18 @ 18
]

{ #category : 'building - event' }
OPBPMNRoassalIconFactory class >> eventEscalation: aBoolean [

	| polygon |
	polygon := RSPolygon new
		           points: {
				           (0 @ -7.7).
				           (5.5 @ 6.0).
				           (0 @ 1.1).
				           (-5.5 @ 6.0) };
		           color: (aBoolean
				            ifTrue: [ Color black ]
				            ifFalse: [ Color white ]);
		           border: (self blackBorderWidth: 1.2);
		           yourself.
	^ self compositeWith: { polygon } extent: 18 @ 18
]

{ #category : 'building - event' }
OPBPMNRoassalIconFactory class >> eventLink: aBoolean [

	| polygon |
	polygon := RSPolygon new
		           points: {
				           (-7.7 @ -3.3).
				           (1.1 @ -3.3).
				           (1.1 @ -7.2).
				           (7.7 @ 0).
				           (1.1 @ 7.2).
				           (1.1 @ 3.3).
				           (-7.7 @ 3.3) };
		           color: (aBoolean
				            ifTrue: [ Color black ]
				            ifFalse: [ Color white ]);
		           border: (self blackBorderWidth: 1.2);
		           yourself.
	^ self compositeWith: { polygon } extent: 18 @ 18
]

{ #category : 'building - event' }
OPBPMNRoassalIconFactory class >> eventMultiple: aBoolean [

	| polygon |
	polygon := RSPolygon new
		           points: {
				           (0 @ -7.7).
				           (7.7 @ -2.2).
				           (5.0 @ 7.2).
				           (-5.0 @ 7.2).
				           (-7.7 @ -2.2) };
		           color: (aBoolean
				            ifTrue: [ Color black ]
				            ifFalse: [ Color white ]);
		           border: (self blackBorderWidth: 1.2);
		           yourself.
	^ self compositeWith: { polygon } extent: 18 @ 18
]

{ #category : 'building - event' }
OPBPMNRoassalIconFactory class >> eventParallelMultiple [

	| polygon |
	polygon := RSPolygon new
		           points: {
				           (-2.4 @ -7.7).
				           (2.4 @ -7.7).
				           (2.4 @ -2.4).
				           (7.7 @ -2.4).
				           (7.7 @ 2.4).
				           (2.4 @ 2.4).
				           (2.4 @ 7.7).
				           (-2.4 @ 7.7).
				           (-2.4 @ 2.4).
				           (-7.7 @ 2.4).
				           (-7.7 @ -2.4).
				           (-2.4 @ -2.4) };
		           color: Color white;
		           border: (self blackBorderWidth: 1.2);
		           yourself.
	^ self compositeWith: { polygon } extent: 18 @ 18
]

{ #category : 'building - event' }
OPBPMNRoassalIconFactory class >> eventSignal: aBoolean [

	| polygon |
	polygon := RSPolygon new
		           points: {
				           (0 @ -7.7).
				           (7.7 @ 6.6).
				           (-7.7 @ 6.6) };
		           color: (aBoolean
				            ifTrue: [ Color black ]
				            ifFalse: [ Color white ]);
		           border: (self blackBorderWidth: 1.2);
		           yourself.
	^ self compositeWith: { polygon } extent: 18 @ 18
]

{ #category : 'building - event' }
OPBPMNRoassalIconFactory class >> eventTerminate [

	| circle |
	circle := RSCircle new
		          size: 20;
		          color: Color black;
		          border: (self blackBorderWidth: 1.0);
		          yourself.
	^ self compositeWith: { circle } extent: 22 @ 22
]

{ #category : 'building - event' }
OPBPMNRoassalIconFactory class >> eventTimer [

	| shapes circle hands |
	shapes := OrderedCollection new.
	circle := RSCircle new
		          size: 18;
		          color: Color white;
		          border: (self blackBorderWidth: 1.2);
		          yourself.
	shapes add: circle.
	0 to: 11 do: [ :eachTick |
			| angle rad p1 p2 |
			angle := eachTick * 30.
			rad := angle degreesToRadians.
			p1 := rad cos * 6.6 @ (rad sin * 6.6).
			p2 := rad cos * 8.6 @ (rad sin * 8.6).
			shapes add: (RSLine new
					 startPoint: p1;
					 endPoint: p2;
					 border: (self blackBorderWidth: 1.0);
					 yourself) ].
	hands := RSPolyline new
		         controlPoints: {
				         (0 @ -5.5).
				         (0 @ 0).
				         (4.4 @ 0) };
		         border: (self blackBorderWidth: 1.3);
		         yourself.
	shapes add: hands.
	^ self compositeWith: shapes extent: 20 @ 20
]

{ #category : 'building - gateway' }
OPBPMNRoassalIconFactory class >> gatewayComplex [

	| border hLine vLine d1 d2 |
	border := self blackBorderWidth: 2.2.
	hLine := RSLine new
		         startPoint: -8.8 @ 0;
		         endPoint: 8.8 @ 0;
		         border: border;
		         yourself.
	vLine := RSLine new
		         startPoint: 0 @ -8.8;
		         endPoint: 0 @ 8.8;
		         border: border;
		         yourself.
	d1 := RSLine new
		      startPoint: -6.0 @ -6.0;
		      endPoint: 6.0 @ 6.0;
		      border: border;
		      yourself.
	d2 := RSLine new
		      startPoint: -6.0 @ 6.0;
		      endPoint: 6.0 @ -6.0;
		      border: border;
		      yourself.
	^ self
		  compositeWith: {
				  hLine.
				  vLine.
				  d1.
				  d2 }
		  extent: 20 @ 20
]

{ #category : 'building - gateway' }
OPBPMNRoassalIconFactory class >> gatewayEvent [

	| outerCircle innerCircle pentagon |
	outerCircle := RSCircle new
		               size: 23;
		               color: Color transparent;
		               border: (self blackBorderWidth: 1.2);
		               yourself.
	innerCircle := RSCircle new
		               size: 18;
		               color: Color transparent;
		               border: (self blackBorderWidth: 1.2);
		               yourself.
	pentagon := RSPolygon new
		            points: {
				            (0 @ -5.3).
				            (5.1 @ -1.7).
				            (3.1 @ 4.3).
				            (-3.1 @ 4.3).
				            (-5.1 @ -1.7) };
		            color: Color transparent;
		            border: (self blackBorderWidth: 1.2);
		            yourself.
	^ self
		  compositeWith: {
				  outerCircle.
				  innerCircle.
				  pentagon }
		  extent: 26 @ 26
]

{ #category : 'building - gateway' }
OPBPMNRoassalIconFactory class >> gatewayExclusive [

	| l1 l2 |
	l1 := RSLine new
		      startPoint: -6.6 @ -6.6;
		      endPoint: 6.6 @ 6.6;
		      border: (self blackBorderWidth: 3.0);
		      yourself.
	l2 := RSLine new
		      startPoint: -6.6 @ 6.6;
		      endPoint: 6.6 @ -6.6;
		      border: (self blackBorderWidth: 3.0);
		      yourself.
	^ self
		  compositeWith: {
				  l1.
				  l2 }
		  extent: 20 @ 20
]

{ #category : 'dispatching' }
OPBPMNRoassalIconFactory class >> gatewayIconForType: aType [
	aType = OPBPMNNodeType ExclusiveEmpty ifTrue: [ ^ self emptyIcon ].
	aType = OPBPMNNodeType Parallel ifTrue: [ ^ self gatewayParallel ].
	aType = OPBPMNNodeType Inclusive ifTrue: [ ^ self gatewayInclusive ].
	aType = OPBPMNNodeType Exclusive ifTrue: [ ^ self gatewayExclusive ].
	aType = OPBPMNNodeType Complex ifTrue: [ ^ self gatewayComplex ].
	aType = OPBPMNNodeType Eventbased ifTrue: [ ^ self gatewayEvent ].
	^ OPBPMNUnknownNodeTypeError signalForType: aType
]

{ #category : 'building - gateway' }
OPBPMNRoassalIconFactory class >> gatewayInclusive [

	| circle |
	circle := RSCircle new
		          size: 20;
		          color: Color transparent;
		          border: (self blackBorderWidth: 2.5);
		          yourself.
	^ self compositeWith: { circle } extent: 22 @ 22
]

{ #category : 'building - gateway' }
OPBPMNRoassalIconFactory class >> gatewayParallel [

	| hLine vLine |
	hLine := RSLine new
		         startPoint: -8.8 @ 0;
		         endPoint: 8.8 @ 0;
		         border: (self blackBorderWidth: 3.0);
		         yourself.
	vLine := RSLine new
		         startPoint: 0 @ -8.8;
		         endPoint: 0 @ 8.8;
		         border: (self blackBorderWidth: 3.0);
		         yourself.
	^ self
		  compositeWith: {
				  hLine.
				  vLine }
		  extent: 20 @ 20
]

{ #category : 'building - activity' }
OPBPMNRoassalIconFactory class >> gearAt: aCenterPoint outerRadius: anOuterRadius innerRadius: anInnerRadius holeRadius: aHoleRadius teeth: aTeethCount [
	| points step border gearPolygon holeCircle |
	border := self blackBorderWidth: 1.1.
	points := OrderedCollection new.
	step := 360.0 / aTeethCount.
	0 to: aTeethCount - 1 do: [ :eachIndex |
		| baseAngle a1 a2 a3 a4 |
		baseAngle := eachIndex * step.
		a1 := (baseAngle - (step * 0.34)) degreesToRadians.
		a2 := (baseAngle - (step * 0.18)) degreesToRadians.
		a3 := (baseAngle + (step * 0.18)) degreesToRadians.
		a4 := (baseAngle + (step * 0.34)) degreesToRadians.
		points add: aCenterPoint + ((a1 cos * anInnerRadius) @ (a1 sin * anInnerRadius)).
		points add: aCenterPoint + ((a2 cos * anOuterRadius) @ (a2 sin * anOuterRadius)).
		points add: aCenterPoint + ((a3 cos * anOuterRadius) @ (a3 sin * anOuterRadius)).
		points add: aCenterPoint + ((a4 cos * anInnerRadius) @ (a4 sin * anInnerRadius)) ].
	gearPolygon := RSPolygon new
		points: points asArray;
		color: Color white;
		border: border;
		yourself.
	holeCircle := RSCircle new
		position: aCenterPoint;
		size: aHoleRadius * 2.0;
		color: Color white;
		border: (self blackBorderWidth: 1.0);
		yourself.
	^ { gearPolygon . holeCircle }
]

{ #category : 'dispatching' }
OPBPMNRoassalIconFactory class >> intermediateEventIconForType: aType [
	aType = OPBPMNNodeType None ifTrue: [ ^ self emptyIcon ].
	aType = OPBPMNNodeType Send ifTrue: [ ^ self activitySendSquare ].
	aType = OPBPMNNodeType Receive ifTrue: [ ^ self activityReceiveSquare ].
	aType = OPBPMNNodeType Timer ifTrue: [ ^ self eventTimer ].
	aType = OPBPMNNodeType Escalation ifTrue: [ ^ self eventEscalation: false ].
	aType = OPBPMNNodeType EscalationThrow ifTrue: [ ^ self eventEscalation: true ].
	aType = OPBPMNNodeType Conditional ifTrue: [ ^ self eventCondition ].
	aType = OPBPMNNodeType Link ifTrue: [ ^ self eventLink: false ].
	aType = OPBPMNNodeType LinkThrow ifTrue: [ ^ self eventLink: true ].
	aType = OPBPMNNodeType Compensation ifTrue: [ ^ self eventCompensation: false ].
	aType = OPBPMNNodeType CompensationThrow ifTrue: [ ^ self eventCompensation: true ].
	aType = OPBPMNNodeType Signal ifTrue: [ ^ self eventSignal: false ].
	aType = OPBPMNNodeType SignalThrow ifTrue: [ ^ self eventSignal: true ].
	aType = OPBPMNNodeType Multiple ifTrue: [ ^ self eventMultiple: false ].
	aType = OPBPMNNodeType MultipleThrow ifTrue: [ ^ self eventMultiple: true ].
	aType = OPBPMNNodeType ParallelMultiple ifTrue: [ ^ self eventParallelMultiple ].
	^ OPBPMNUnknownNodeTypeError signalForType: aType
]

{ #category : 'building - data object' }
OPBPMNRoassalIconFactory class >> lowerCylinderArcAtY: aCenterY radiusX: aRadiusX radiusY: aRadiusY border: aBorder [
	| arcPoints |
	arcPoints := (0 to: 20) collect: [ :eachStep |
		| rad |
		rad := eachStep * Float pi / 20.0.
		(rad cos * aRadiusX) @ (aCenterY + (rad sin * aRadiusY)) ].
	^ RSPolyline new
		controlPoints: arcPoints;
		border: aBorder;
		yourself
]

{ #category : 'building - markers' }
OPBPMNRoassalIconFactory class >> markerAdhoc [

	| tilde |
	tilde := RSPolyline new
		         controlPoints: {
				         (-6.6 @ 1.7).
				         (-3.3 @ -2.8).
				         (3.3 @ 2.8).
				         (6.6 @ -1.7) };
		         border: (self blackBorderWidth: 1.8);
		         yourself.
	^ self compositeWith: { tilde } extent: 16 @ 16
]

{ #category : 'building - markers' }
OPBPMNRoassalIconFactory class >> markerCompensation [

	| border t1 t2 |
	border := self blackBorderWidth: 1.2.
	t1 := RSPolygon new
		      points: {
				      (-6.6 @ 0).
				      (0 @ -5.0).
				      (0 @ 5.0) };
		      color: Color white;
		      border: border;
		      yourself.
	t2 := RSPolygon new
		      points: {
				      (0 @ 0).
				      (6.6 @ -5.0).
				      (6.6 @ 5.0) };
		      color: Color white;
		      border: border;
		      yourself.
	^ self
		  compositeWith: {
				  t1.
				  t2 }
		  extent: 16 @ 16
]

{ #category : 'building - markers' }
OPBPMNRoassalIconFactory class >> markerLoop [

	| arcPoints loopLine arrowHead |
	arcPoints := (0 to: 16) collect: [ :eachStep |
			             | angleDeg rad |
			             angleDeg := 55.0 - (eachStep * (290.0 / 16.0)).
			             rad := angleDeg degreesToRadians.
			             rad cos * 5.3 @ (rad sin * 5.3) ].
	loopLine := RSPolyline new
		            controlPoints: arcPoints;
		            border: (self blackBorderWidth: 1.3);
		            yourself.
	arrowHead := RSPolyline new
		             controlPoints: {
				             (-2.6 @ 1.2).
				             (-3.0 @ 4.3).
				             (-6.2 @ 4.5) };
		             border: (self blackBorderWidth: 1.3);
		             yourself.
	^ self
		  compositeWith: {
				  loopLine.
				  arrowHead }
		  extent: 16 @ 16
]

{ #category : 'building - markers' }
OPBPMNRoassalIconFactory class >> markerParallel [

	| border l1 l2 l3 |
	border := self blackBorderWidth: 1.5.
	l1 := RSLine new
		      startPoint: -4.4 @ -5.5;
		      endPoint: -4.4 @ 5.5;
		      border: border;
		      yourself.
	l2 := RSLine new
		      startPoint: 0 @ -5.5;
		      endPoint: 0 @ 5.5;
		      border: border;
		      yourself.
	l3 := RSLine new
		      startPoint: 4.4 @ -5.5;
		      endPoint: 4.4 @ 5.5;
		      border: border;
		      yourself.
	^ self
		  compositeWith: {
				  l1.
				  l2.
				  l3 }
		  extent: 16 @ 16
]

{ #category : 'building - markers' }
OPBPMNRoassalIconFactory class >> markerSequential [

	| border l1 l2 l3 |
	border := self blackBorderWidth: 1.5.
	l1 := RSLine new
		      startPoint: -5.5 @ -4.4;
		      endPoint: 5.5 @ -4.4;
		      border: border;
		      yourself.
	l2 := RSLine new
		      startPoint: -5.5 @ 0;
		      endPoint: 5.5 @ 0;
		      border: border;
		      yourself.
	l3 := RSLine new
		      startPoint: -5.5 @ 4.4;
		      endPoint: 5.5 @ 4.4;
		      border: border;
		      yourself.
	^ self
		  compositeWith: {
				  l1.
				  l2.
				  l3 }
		  extent: 16 @ 16
]

{ #category : 'building - markers' }
OPBPMNRoassalIconFactory class >> markerSubProcess [

	| box hLine vLine |
	box := RSBox new
		       extent: 13 @ 13;
		       color: Color white;
		       border: (self blackBorderWidth: 1.2);
		       yourself.
	hLine := RSLine new
		         startPoint: -3.9 @ 0;
		         endPoint: 3.9 @ 0;
		         border: (self blackBorderWidth: 1.3);
		         yourself.
	vLine := RSLine new
		         startPoint: 0 @ -3.9;
		         endPoint: 0 @ 3.9;
		         border: (self blackBorderWidth: 1.3);
		         yourself.
	^ self
		  compositeWith: {
				  box.
				  hLine.
				  vLine }
		  extent: 16 @ 16
]

{ #category : 'dispatching' }
OPBPMNRoassalIconFactory class >> startEventIconForType: aType [
	aType = OPBPMNNodeType None ifTrue: [ ^ self emptyIcon ].
	aType = OPBPMNNodeType Receive ifTrue: [ ^ self activityReceiveSquare ].
	aType = OPBPMNNodeType Timer ifTrue: [ ^ self eventTimer ].
	aType = OPBPMNNodeType Escalation ifTrue: [ ^ self eventEscalation: false ].
	aType = OPBPMNNodeType Conditional ifTrue: [ ^ self eventCondition ].
	aType = OPBPMNNodeType Error ifTrue: [ ^ self eventError: false ].
	aType = OPBPMNNodeType Compensation ifTrue: [ ^ self eventCompensation: false ].
	aType = OPBPMNNodeType Signal ifTrue: [ ^ self eventSignal: false ].
	aType = OPBPMNNodeType Multiple ifTrue: [ ^ self eventMultiple: false ].
	aType = OPBPMNNodeType ParallelMultiple ifTrue: [ ^ self eventParallelMultiple ].
	^ OPBPMNUnknownNodeTypeError signalForType: aType
]

{ #category : 'dispatching' }
OPBPMNRoassalIconFactory class >> subProcessMarkerForType: aType [
	aType = OPBPMNNodeType None ifTrue: [ ^ self emptyIcon ].
	aType = OPBPMNNodeType MarkerParallel ifTrue: [ ^ self markerParallel ].
	aType = OPBPMNNodeType MarkerSequential ifTrue: [ ^ self markerSequential ].
	aType = OPBPMNNodeType MarkerLoop ifTrue: [ ^ self markerLoop ].
	aType = OPBPMNNodeType MarkerCompensation ifTrue: [ ^ self markerCompensation ].
	aType = OPBPMNNodeType MarkerAdhoc ifTrue: [ ^ self markerAdhoc ].
	^ OPBPMNUnknownNodeTypeError signalForType: aType
]

{ #category : 'building - common' }
OPBPMNRoassalIconFactory class >> whiteBorderWidth: aNumber [
	^ RSBorder new
		color: Color white;
		width: aNumber;
		capRound;
		joinRound;
		yourself
]
