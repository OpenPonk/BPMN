Class {
	#name : #OPBPMNPoolShape,
	#superclass : #OPShape,
	#instVars : [
		'label',
		'laneLines',
		'laneLabels',
		'b1',
		'b2',
		'borderColor'
	],
	#category : #'OpenPonk-BPMN-DiagramElements'
}

{ #category : #adding }
OPBPMNPoolShape >> addLanes: aNumber [

	| b4 b5 e2 w h lb |
	self removeLaneLines.
	w := roassalShape width.
	h := roassalShape height.
	2 to: aNumber do: [ :i | 
		b4 := RSBox new size: 0.1.
		b5 := RSBox new size: 0.1.
		roassalShape add: b4.
		roassalShape add: b5.
		roassalShape adjustToChildren.
		b4 position:
			b1 width / 2 @ (i - 1 / aNumber * 2 * b1 height - b1 height / 2).
		b5 position: b1 width / 2 - b1 width + b2 width
			@ (i - 1 / aNumber * 2 * b1 height - b1 height / 2).
		"b5 position: (w/2)-w+(30) @ (((i-1)/ aNumber*2*(b1 height))- b1 height/2)."

		e2 := RSLine new
			      from: b4;
			      to: b5.

		self canvas add: e2.
		laneLines add: e2 ].

	aNumber > 1 ifTrue: [ 
		1 to: aNumber do: [ :i | 
			lb := RSLabel new.
			roassalShape add: lb.
			laneLabels add: lb.
			lb position:
				0 @ (i - 1 / aNumber * 2 * b1 height - b1 height / 2 + 8) ] ]
]

{ #category : #accessing }
OPBPMNPoolShape >> borderColor [

	^ borderColor
]

{ #category : #accessing }
OPBPMNPoolShape >> borderColor: aColor [

	borderColor := aColor
]

{ #category : #accessing }
OPBPMNPoolShape >> color [

	^ self stylePropertyNamed: #fillColor ifAbsent: [ Color transparent ]
]

{ #category : #accessing }
OPBPMNPoolShape >> color: aColor [

	^ self stylePropertyNamed: #fillColor put: aColor
]

{ #category : #accessing }
OPBPMNPoolShape >> createRoassalShape [
| com |
com := RSComposite new.
b1 := RSBox new width: 550; height: 300; color: Color white; borderColor: Color black.
b2 := RSBox new width: 30; height: 300; color: Color white; borderColor: Color black.
com add: b1.
com add: b2.

com adjustToChildren.
b2 position: -260@0. 
	^ com
]

{ #category : #accessing }
OPBPMNPoolShape >> initialize [
	super initialize.
	laneLines := OrderedCollection new.
	laneLabels := OrderedCollection new.
]

{ #category : #adding }
OPBPMNPoolShape >> remove [
	self removeLaneLines.
	super remove.
]

{ #category : #accessing }
OPBPMNPoolShape >> removeLaneLines [

	laneLines do: [ :each | self canvas removeShape: each. ].
	"laneLabels do: [ :each | self canvas removeShape: each. ]."
	laneLabels do: [ :each | self roassalShape removeShape: each. ].
	laneLines removeAll.
	laneLabels removeAll.
]

{ #category : #accessing }
OPBPMNPoolShape >> renderBasicShape [

	^ self createRoassalShape model: self
]

{ #category : #accessing }
OPBPMNPoolShape >> renderShapeDetails [

	| selectable resizable |
	label := RSLabel new
		         rotateByDegrees: -90;
		         color: Color black.
	self roassalShape add: label.
	label position: b1 width / 2 - b1 width + 11 @ 0.
	"self canvas add: label.
	RSLocation new
		stick: label on: self roassalShape;
		left;
		offset: 4 @ 0.
	self roassalShape when: RSShapeRemovedEvent do: [ label remove ]."

	"roassalShape @ OPRSSelectionDraggable.
	roassalShape @ RSTransformable.
	selectable := OPRSSelectable new.
	self setupHighlight: selectable.
	roassalShape @ selectable.
	self updateRenderFromModel."
	
selectable := OPRSSelectable new.
	selectable highlightBorderColor: Color blue.
	resizable := OPRSResizable onShape: b1. "TODO use something like this"
	roassalShape @ selectable.
	self roassalShape
@ OPRSSelectionDraggableBorder thatAlsoDragsContainedShapes;
		@ RSTransformable.
		self updateRenderFromModel.
]

{ #category : #accessing }
OPBPMNPoolShape >> setupHighlight: aHighlightable [

	aHighlightable highlightBorderColor: Color blue
]

{ #category : #accessing }
OPBPMNPoolShape >> updateRenderFromModel [
	| aCnt |
	self modelElement name ifNotNil: [ 
		label text: self modelElement name ].
	"roassalShape width: self modelElement width.
	roassalShape height: self modelElement height.
	lane width: self modelElement width.
	lane height: self modelElement height/2."
	self addLanes: self modelElement lanes.
	aCnt := 1.
	self modelElement laneNames do: [ :each | (laneLabels at: aCnt) text: each. aCnt := aCnt + 1. ].
	super updateRenderFromModel.
	roassalShape signalUpdate
]

{ #category : #accessing }
OPBPMNPoolShape >> updateRenderFromSelf [

	self isRendered ifFalse: [ ^ self ].
	roassalShape color: self color.

	super updateRenderFromSelf
]
