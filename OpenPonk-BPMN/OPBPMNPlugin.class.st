Class {
	#name : #OPBPMNPlugin,
	#superclass : #OPPlugin,
	#category : #'OpenPonk-BPMN-Adapters'
}

{ #category : #accessing }
OPBPMNPlugin >> diagramControllerClass [
	^ OPBPMNDiagramController
]

{ #category : #accessing }
OPBPMNPlugin >> icon [
	^ OPBPMNIcon current logo
]

{ #category : #accessing }
OPBPMNPlugin >> layouterClass [
	"Create your own subclass of OPLayouter or use OPNoLayouter which does nothing"
	^ OPBPMNLayouter
]

{ #category : #accessing }
OPBPMNPlugin >> modelClass [
	^ OPBPMNModel
]

{ #category : #accessing }
OPBPMNPlugin >> modelSerializerClass [
	^ OPStonModelSerializer
]

{ #category : #accessing }
OPBPMNPlugin >> name [
	^ 'BPMN'
]

{ #category : #accessing }
OPBPMNPlugin >> supportsHidingElements [
	^ true
]
