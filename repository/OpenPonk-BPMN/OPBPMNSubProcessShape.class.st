"
I render an expanded BPMN SubProcess as a Roassal bound node, managing the boundary box and inner type icons.
"
Class {
	#name : 'OPBPMNSubProcessShape',
	#superclass : 'OPBPMNNodeShape',
	#instVars : [
		'labeled'
	],
	#category : 'OpenPonk-BPMN-DiagramElements',
	#package : 'OpenPonk-BPMN',
	#tag : 'DiagramElements'
}

{ #category : 'connecting' }
OPBPMNSubProcessShape >> createRoassalShape [

	^ RSBox new
		  extent: 150 @ 100;
		  border: (RSBorder new
				   color: Color black;
				   width: 1);
		  cornerRadius: 10;
		  yourself
]

{ #category : 'removing' }
OPBPMNSubProcessShape >> removeRender [
	super removeRender.
	labeled := nil
]

{ #category : 'rendering' }
OPBPMNSubProcessShape >> renderShapeDetails [
	labeled := OPRSLabeled new.
	labeled color: Color black.
	labeled shapeBuilder wrapStrategy: RSWrapStrategy new.
	labeled location top offset: 0 @ 17.
	labeled text: ''.
	roassalShape @ labeled.

	roassalShape @ RSTransformable
]

{ #category : 'connecting' }
OPBPMNSubProcessShape >> typeIconForModel [

	
]

{ #category : 'update' }
OPBPMNSubProcessShape >> updateIcon [

	
]

{ #category : 'rendering' }
OPBPMNSubProcessShape >> updateLabel [
	labeled ifNotNil: [
		labeled text: (self modelElement name ifNil: [ '' ]) ]
]

{ #category : 'rendering' }
OPBPMNSubProcessShape >> updateRenderFromSelf [

	self isRendered ifFalse: [ ^ self ].
	roassalShape color: self color.

	super updateRenderFromSelf
]
