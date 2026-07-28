Class {
	#name : 'OPBPMNAnnotationShape',
	#superclass : 'OPBoundNode',
	#instVars : [
		'labeled',
		'wrappedForWidth',
		'borderCoveringBox',
		'borderBox',
		'lastText'
	],
	#category : 'OpenPonk-BPMN-DiagramElements',
	#package : 'OpenPonk-BPMN',
	#tag : 'DiagramElements'
}

{ #category : 'update' }
OPBPMNAnnotationShape >> accomodateText [

	Transcript crShow:
		'MAIN: ' , self roassalShape extent asString , ' -> '
		, (labeled labelShape extent + (self textPadding * 2) max:
				 self minExtent) asString.
	self halt. 
	self roassalShape extent:
		(labeled labelShape extent + (self textPadding * 2) max:
			 self minExtent)
]

{ #category : 'accessing' }
OPBPMNAnnotationShape >> attachedShapes [

	^ {
		  borderBox.
		  borderCoveringBox.
		  (labeled ifNotNil: [ :l | l labelShape ]) }
]

{ #category : 'rendering' }
OPBPMNAnnotationShape >> minExtent [

	^ self visibleBorderWidth + 2 @ 30
]

{ #category : 'removing' }
OPBPMNAnnotationShape >> removeRender [

	super removeRender.
	borderBox := nil.
	borderCoveringBox := nil.
	labeled := nil
]

{ #category : 'rendering' }
OPBPMNAnnotationShape >> renderBasicShape [
	"should render a simple shape without using any modelElement info and any advanced shape complexity"

	| box |
	box := RSBox new
		  color: Color transparent;
		  yourself.
		
		box
		  when: RSExtentChangedEvent
		  do: [ :event | self halt. ]
		  for: self;
		  extent: 5@5.
		
	^ box
]

{ #category : 'rendering' }
OPBPMNAnnotationShape >> renderShapeDetails [

	borderBox := RSBox new
		             color: Color white;
		             borderColor: Color black;
		             model: self;
		             width: self visibleBorderWidth;
		             yourself.

	borderCoveringBox := RSBox new
		                     color: Color white;
		                     borderColor: Color white;
		                     model: self;
		                     yourself.
	borderCoveringBox border joinMiter.

	roassalShape canvas
		add: borderBox;
		add: borderCoveringBox.

	labeled := OPRSLabeled new.
	labeled model: self.
	labeled color: Color black.
	labeled shapeBuilder wrapStrategy: RSWrapStrategy new.
	labeled text: ''.

	self roassalShape @ labeled.

	labeled location
		inner;
		left;
		middle;
		offset: self textPadding @ 0.

	roassalShape
		when: RSPositionChangedEvent
		do: [ self updateAttachedElements ]
		for: self.
	roassalShape
		when: RSExtentChangedEvent
		do: [ self updateBorderBoxes ]
		for: self.

	self updateAttachedElements
]

{ #category : 'interactions' }
OPBPMNAnnotationShape >> selectableInteraction [

	^ OPRSSelectable highlightBorderColorBlue
]

{ #category : 'creating - subelements' }
OPBPMNAnnotationShape >> textPadding [

	^ 5
]

{ #category : 'rendering' }
OPBPMNAnnotationShape >> updateAttachedElements [
		
	self accomodateText.
	self updateBorderBoxes
]

{ #category : 'update' }
OPBPMNAnnotationShape >> updateBorderBoxes [

	Transcript crShow:
		'COVER EX: ' , borderCoveringBox extent asString , ' -> '
		, (roassalShape extent - (borderBox width @ 2)) asString.

	borderCoveringBox extent: roassalShape extent - (borderBox width @ 2).

	borderCoveringBox translateTo:
		roassalShape position + (self visibleBorderWidth / 2 - 1 @ 0).

	Transcript crShow: 'BORDER EX: ' , borderBox extent asString , ' -> '
		, (borderBox width @ (roassalShape height - 2)) asString.

	borderBox height: roassalShape height - 2.

	borderBox translateTo:
		roassalShape position - (borderCoveringBox width / 2 - 1 @ 0)
]

{ #category : 'rendering' }
OPBPMNAnnotationShape >> updateRenderFromModel [

	lastText = self modelElement text ifTrue: [
		^ super updateRenderFromModel ].
	
	lastText := self modelElement text.
	labeled text: lastText.
	
	self accomodateText.
	super updateRenderFromModel.
	roassalShape signalUpdate
]

{ #category : 'hooks' }
OPBPMNAnnotationShape >> visibleBorderWidth [

	^ 20
]
