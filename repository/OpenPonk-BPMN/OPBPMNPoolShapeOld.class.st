Class {
	#name : #OPBPMNPoolShapeOld,
	#superclass : #OPShape,
	#instVars : [
		'label',
		'lane'
	],
	#category : #'OpenPonk-BPMN-DiagramElements'
}

{ #category : #accessing }
OPBPMNPoolShapeOld >> color [

	^ self stylePropertyNamed: #fillColor ifAbsent: [ Color transparent ]
]

{ #category : #accessing }
OPBPMNPoolShapeOld >> color: aColor [

	^ self stylePropertyNamed: #fillColor put: aColor
]

{ #category : #accessing }
OPBPMNPoolShapeOld >> createRoassalShape [

	| points |
	points := { 
		          (0 @ 0).
		          (550 @ 0).
		          (550 @ 300).
		          (0 @ 300).
		          (50 @ 300).
		          (50 @ 0).
		          (0 @ 0).
		          (0 @ 300) }.
	^ RSPolygon new
		  points: points;
		  borderColor: Color black;
		  "RSBox new
		extent: 550@200;
		border: (RSBorder new
		color: (Color black);
		width: 2);
		yourself"
			  yourself
]

{ #category : #accessing }
OPBPMNPoolShapeOld >> renderBasicShape [

	^ self createRoassalShape model: self
]

{ #category : #accessing }
OPBPMNPoolShapeOld >> renderShapeDetails [

	| selectable |
	label := RSLabel new
		         rotateByDegrees: -90;
		         color: Color black.
	self canvas add: label.
	RSLocation new
		stick: label on: self roassalShape;
		left;
		offset: 12 @ 0.
	self roassalShape when: RSShapeRemovedEvent do: [ label remove ].

	lane := "RSLine new
		        startPoint: 0@0;
				  endPoint: 550@0;
		        width: 2."
		RSBox new
		extent: 550@200;
		border: (RSBorder new
		color: (Color black);
		width: 2);
		yourself.
	self canvas add: lane.
	RSLocation new stick: lane on: self roassalShape.
	self roassalShape when: RSShapeRemovedEvent do: [ lane remove ].
	"self roassalShape when: RSScaleChangedEvent do: [ :evt | 
		lane width: (self scaleFor: evt) * width.
		evt signalUpdate ]."

	roassalShape @ OPRSSelectionDraggable.
	"roassalShape @ RSTransformable."
	selectable := OPRSSelectable new.
	self setupHighlight: selectable.
	roassalShape @ selectable.
	self updateRenderFromModel.
]

{ #category : #accessing }
OPBPMNPoolShapeOld >> setupHighlight: aHighlightable [

	aHighlightable highlightBorderColor: Color blue
]

{ #category : #accessing }
OPBPMNPoolShapeOld >> updateRenderFromModel [

	self modelElement name ifNotNil: [ 
		label text: self modelElement name ].
	roassalShape width: self modelElement width.
	roassalShape height: self modelElement height.
	lane width: self modelElement width.
	lane height: self modelElement height/2.
	
	super updateRenderFromModel.
	roassalShape signalUpdate
]

{ #category : #accessing }
OPBPMNPoolShapeOld >> updateRenderFromSelf [

	self isRendered ifFalse: [ ^ self ].
	roassalShape color: self color.
	
	RSLocation new
		stick: lane on: self roassalShape;
		offset: 0 @ self modelElement height/4.
	super updateRenderFromSelf
]
