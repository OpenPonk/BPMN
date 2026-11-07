"
I render a BPMN Boundary Event as a Roassal shape. I manage the visual representation of two concentric circles and handle attachment to the border of a host activity shape.
"
Class {
	#name : 'OPBPMNBoundaryEventShape',
	#superclass : 'OPBPMNNodeShape',
	#instVars : [
		'borderIn',
		'borderOut',
		'innerCircle'
	],
	#category : 'OpenPonk-BPMN-DiagramElements',
	#package : 'OpenPonk-BPMN',
	#tag : 'DiagramElements'
}

{ #category : 'rendering' }
OPBPMNBoundaryEventShape >> attachToHostShape [
	| hostElement hostRoassalShape boundarySiblings siblingIndex horizontalOffset |
	self isRendered ifFalse: [ ^ self ].
	hostElement := self hostDiagramElement.
	(hostElement isNil or: [ hostElement isRendered not ]) ifTrue: [ ^ self ].
	hostRoassalShape := hostElement roassalShape.
	hostRoassalShape ifNil: [ ^ self ].
	boundarySiblings := (self modelElement isNotNil and: [ self modelElement owner isNotNil ])
		ifTrue: [
			self modelElement owner elements select: [ :eachElement |
				eachElement isKindOf: OPBPMNBoundaryEventModel ] ]
		ifFalse: [
			(hostElement ownedElements select: [ :eachElement |
				(eachElement isKindOf: OPBPMNBoundaryEventShape) and: [ eachElement isRendered ] ])
				collect: #modelElement ].
	siblingIndex := (boundarySiblings indexOf: self modelElement) max: 1.
	horizontalOffset := -1 - ((siblingIndex - 1) * 44).
	RSLocation new
		bottom;
		right;
		offset: horizontalOffset @ 22;
		move: self roassalShape
		on: hostRoassalShape
]

{ #category : 'accessing' }
OPBPMNBoundaryEventShape >> attachedShapes [

	^ super attachedShapes , { innerCircle }
]

{ #category : 'connecting' }
OPBPMNBoundaryEventShape >> createBorder [

	self modelElement
		ifNil: [ 
			borderIn := RSBorder new
				            dashArray: #( 1 0 );
				            color: Color black.
			borderOut := RSBorder new
				             dashArray: #( 1 0 );
				             color: Color black ]
		ifNotNil: [ 
			self modelElement isNonInterrupting
				ifTrue: [ 
					borderIn dashArray: #( 9 7 ).
					borderOut dashArray: #( 11 10 ) ]
				ifFalse: [ 
					borderIn dashArray: #( 1 0 ).
					borderOut dashArray: #( 1 0 ) ] ]
]

{ #category : 'connecting' }
OPBPMNBoundaryEventShape >> createRoassalShape [

	^ RSCircle new
		  size: 39;
		  borderColor: Color black;
		  border: borderOut;
		  yourself
]

{ #category : 'accessing' }
OPBPMNBoundaryEventShape >> hostDiagramElement [
	| candidate |
	candidate := self owningElement.
	(candidate isNotNil and: [ candidate isKindOf: OPBoundNode ])
		ifTrue: [ ^ candidate ].
	^ nil
]

{ #category : 'initialization' }
OPBPMNBoundaryEventShape >> initialize [
	super initialize.
	self createBorder.
]

{ #category : 'removing' }
OPBPMNBoundaryEventShape >> removeRender [
	self unsubscribeFromHostShape.
	super removeRender.
	innerCircle := nil.
	self repositionSiblingBoundaryShapes
]

{ #category : 'rendering' }
OPBPMNBoundaryEventShape >> renderShapeDetails [
	| label |
	label := RSLabeled new.
	label location below offset: 0 @ 2.
	label shapeBuilder labelShape color: Color black.
	roassalShape addInteraction: label.
	self color: (Color fromHexString: 'fdd2d2').
	icon := RSBitmap new
		form: self typeIconForModel;
		yourself.
	self canvas add: icon.
	RSLocation new stick: icon on: self roassalShape.

	innerCircle := RSCircle new
		size: 31;
		borderColor: Color black;
		color: Color transparent;
		border: borderIn;
		yourself.
	self canvas add: innerCircle.
	RSLocation new stick: innerCircle on: self roassalShape.
	self subscribeToHostShape.
	self attachToHostShape.
	self repositionSiblingBoundaryShapes
]

{ #category : 'rendering' }
OPBPMNBoundaryEventShape >> repositionSiblingBoundaryShapes [
	| hostDiagramElement |
	hostDiagramElement := self owningElement.
	hostDiagramElement ifNil: [ ^ self ].
	hostDiagramElement ownedElements do: [ :eachOwnedElement |
		(eachOwnedElement isKindOf: OPBPMNBoundaryEventShape) ifTrue: [
			eachOwnedElement attachToHostShape ] ]
]

{ #category : 'interactions' }
OPBPMNBoundaryEventShape >> shouldBePositionableByUser [
	"Boundary events are structurally attached to their enclosing activity or subprocess via RSLocation and cannot be independently positioned."

	^ false
]

{ #category : 'rendering' }
OPBPMNBoundaryEventShape >> subscribeToHostShape [
	| hostElement |
	hostElement := self hostDiagramElement.
	(hostElement isNil or: [ hostElement isRendered not ]) ifTrue: [ ^ self ].
	hostElement roassalShape announcer unsubscribe: self.
	hostElement roassalShape
		when: RSPositionChangedEvent
		do: [ self attachToHostShape ]
		for: self.
	hostElement roassalShape
		when: RSExtentChangedEvent
		do: [ self attachToHostShape ]
		for: self
]

{ #category : 'rendering' }
OPBPMNBoundaryEventShape >> unsubscribeFromHostShape [
	| hostElement |
	hostElement := self hostDiagramElement.
	(hostElement isNotNil and: [ hostElement roassalShape isNotNil ]) ifTrue: [
		hostElement roassalShape announcer unsubscribe: self ]
]

{ #category : 'rendering' }
OPBPMNBoundaryEventShape >> updateRenderFromModel [
	(roassalShape propertyAt: #RSLabeled) text: self modelElement name.
	self updateIcon.
	self createBorder.
	self subscribeToHostShape.
	self attachToHostShape.
	self repositionSiblingBoundaryShapes.
	super updateRenderFromModel.
	roassalShape signalUpdate
]
