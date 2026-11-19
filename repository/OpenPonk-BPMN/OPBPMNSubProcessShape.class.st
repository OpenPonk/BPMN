"
I render an expanded BPMN SubProcess as a Roassal bound node, managing the boundary box and inner type icons.
"
Class {
	#name : 'OPBPMNSubProcessShape',
	#superclass : 'OPBPMNNodeShape',
	#instVars : [
		'labeled',
		'wrappedForWidth'
	],
	#category : 'OpenPonk-BPMN-DiagramElements',
	#package : 'OpenPonk-BPMN',
	#tag : 'DiagramElements'
}

{ #category : 'layout' }
OPBPMNSubProcessShape >> adaptBoundsToInnerBounds: anInnerRectangle [
	"Adapts subprocess shape extent and position to safely enclose inner nodes."

	| requiredExtent |
	requiredExtent := anInnerRectangle extent + (70 @ 60) max: 250 @ 150.
	self roassalShape extent: requiredExtent.
	self roassalShape translateTo: anInnerRectangle center
]

{ #category : 'interactions' }
OPBPMNSubProcessShape >> addSelectionDraggableInteraction [
	roassalShape @ (OPRSSelectionDraggable thatAlsoDragsShapesProvidedByBlock: [ self innerDraggableRoassalShapes ])
]

{ #category : 'connecting' }
OPBPMNSubProcessShape >> createRoassalShape [

	^ RSBox new
		  extent: 190 @ 125;
		  border: (RSBorder new
				   color: Color black;
				   width: 1);
		  cornerRadius: 10;
		  yourself
]

{ #category : 'rendering' }
OPBPMNSubProcessShape >> createTypeIconShape [
	self modelElement ifNil: [ ^ OPBPMNRoassalIconFactory emptyIcon ].
	^ OPBPMNRoassalIconFactory subProcessMarkerForType: self modelElement type
]

{ #category : 'rendering' }
OPBPMNSubProcessShape >> iconLocation [
	^ RSLocation new
		inner;
		bottom;
		center;
		offset: 0 @ -4;
		yourself
]

{ #category : 'testing' }
OPBPMNSubProcessShape >> isContainer [
	^ true
]

{ #category : 'removing' }
OPBPMNSubProcessShape >> removeRender [

	roassalShape ifNotNil: [ :shape | shape announcer unsubscribe: self ].
	super removeRender.
	labeled := nil.
	wrappedForWidth := nil
]

{ #category : 'rendering' }
OPBPMNSubProcessShape >> renderShapeDetails [

	labeled := OPRSLabeled new.
	labeled color: Color black.
	labeled shapeBuilder wrapStrategy: (RSWrapStrategy new wrapMaxWidth: self wrapMaxWidth).
	labeled location
		inner;
		top;
		center;
		offset: 0 @ 6.
	labeled text: ''.
	roassalShape @ labeled.
	wrappedForWidth := roassalShape width.
	roassalShape
		when: RSExtentChangedEvent
		do: [
				(wrappedForWidth isNil or: [ (roassalShape width closeTo: wrappedForWidth absolutePrecision: 0.99) not ]) ifTrue: [
					self updateLabel ] ]
		for: self.

	icon := self createTypeIconShape.
	self canvas add: icon.
	self attachIconShape
]

{ #category : 'interactions' }
OPBPMNSubProcessShape >> shouldBeResizableByUser [
	"Subprocesses are expandable container nodes that can be resized by the user or layout algorithms."

	^ true
]

{ #category : 'rendering' }
OPBPMNSubProcessShape >> textPadding [

	^ 8
]

{ #category : 'rendering' }
OPBPMNSubProcessShape >> updateLabel [

	labeled ifNil: [ ^ self ].
	wrappedForWidth := roassalShape width.
	labeled
		wrapMaxWidth: self wrapMaxWidth;
		text: (self modelElement name ifNil: [ '' ])
]

{ #category : 'rendering' }
OPBPMNSubProcessShape >> updateRenderFromSelf [

	self isRendered ifFalse: [ ^ self ].
	roassalShape color: self color.

	super updateRenderFromSelf
]

{ #category : 'rendering' }
OPBPMNSubProcessShape >> wrapMaxWidth [

	^ self width - (self textPadding * 2) max: 20
]
