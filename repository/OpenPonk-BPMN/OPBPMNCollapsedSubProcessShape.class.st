"
I render a collapsed BPMN SubProcess, displaying a rounded rectangle with a standard plus marker at the bottom center to indicate hidden internal structure.
"
Class {
	#name : 'OPBPMNCollapsedSubProcessShape',
	#superclass : 'OPBPMNNodeShape',
	#instVars : [
		'subprocessIcon',
		'border',
		'labeled'
	],
	#category : 'OpenPonk-BPMN-DiagramElements',
	#package : 'OpenPonk-BPMN',
	#tag : 'DiagramElements'
}

{ #category : 'rendering' }
OPBPMNCollapsedSubProcessShape >> attachIconShape [
	super attachIconShape.
	subprocessIcon ifNotNil: [
		self subprocessIconLocation stick: subprocessIcon on: self roassalShape ]
]

{ #category : 'accessing' }
OPBPMNCollapsedSubProcessShape >> attachedShapes [

	^ super attachedShapes , { subprocessIcon }
]

{ #category : 'connecting' }
OPBPMNCollapsedSubProcessShape >> createBorder [

	self modelElement
		ifNil: [ 
			border := RSBorder new
							width: 1;
				          color: Color black ]
		ifNotNil: [ 
			self modelElement isCallActivity 
				ifTrue: [ border width: 5 ]
				ifFalse: [ border width: 1 ] ]
]

{ #category : 'connecting' }
OPBPMNCollapsedSubProcessShape >> createRoassalShape [
	^ RSBox new
		extent: 85@55;
		border: border;
		cornerRadius: 10;
		yourself
	
]

{ #category : 'rendering' }
OPBPMNCollapsedSubProcessShape >> createTypeIconShape [
	self modelElement ifNil: [ ^ OPBPMNRoassalIconFactory emptyIcon ].
	^ OPBPMNRoassalIconFactory subProcessMarkerForType: self modelElement type
]

{ #category : 'rendering' }
OPBPMNCollapsedSubProcessShape >> iconLocation [
	^ RSLocation new
		offset: -16 @ 16;
		yourself
]

{ #category : 'initialization' }
OPBPMNCollapsedSubProcessShape >> initialize [
	super initialize.
	self createBorder.
	
]

{ #category : 'removing' }
OPBPMNCollapsedSubProcessShape >> removeRender [
	super removeRender.
	subprocessIcon := nil.
	labeled := nil
]

{ #category : 'rendering' }
OPBPMNCollapsedSubProcessShape >> renderShapeDetails [
	labeled := OPRSLabeled new.
	labeled color: Color black.
	labeled shapeBuilder wrapStrategy: RSWrapStrategy new.
	labeled location middle.
	labeled text: ''.
	roassalShape @ labeled.

	subprocessIcon := OPBPMNRoassalIconFactory markerSubProcess.
	icon := self createTypeIconShape.
	self canvas add: subprocessIcon.
	self canvas add: icon.
	self attachIconShape.
	self color: (Color fromHexString: 'f2f2f2')
]

{ #category : 'rendering' }
OPBPMNCollapsedSubProcessShape >> subprocessIconLocation [
	^ RSLocation new
		offset: 0 @ 16;
		yourself
]

{ #category : 'rendering' }
OPBPMNCollapsedSubProcessShape >> updateIconPosition [
	super updateIconPosition.
	subprocessIcon ifNotNil: [
		self subprocessIconLocation move: subprocessIcon on: self roassalShape ]
]

{ #category : 'rendering' }
OPBPMNCollapsedSubProcessShape >> updateLabel [
	labeled ifNotNil: [
		labeled text: (self modelElement name ifNil: [ '' ]) ]
]

{ #category : 'rendering' }
OPBPMNCollapsedSubProcessShape >> updateRenderFromModel [
	self createBorder.
	super updateRenderFromModel
]
