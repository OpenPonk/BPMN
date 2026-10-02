"
I represent a BPMN Text Annotation. I store the textual content and track outgoing associations to other diagram elements.
"
Class {
	#name : 'OPBPMNAnnotationModel',
	#superclass : 'OPBPMNNodeModel',
	#category : 'OpenPonk-BPMN-Models',
	#package : 'OpenPonk-BPMN',
	#tag : 'Models'
}

{ #category : 'accessing' }
OPBPMNAnnotationModel >> nodes [

	^ {  }
]

{ #category : 'printing' }
OPBPMNAnnotationModel >> printIdType [
	^ '_6-'
]

{ #category : 'printing' }
OPBPMNAnnotationModel >> printType [
	^ 'textAnnotation'
]

{ #category : 'accessing' }
OPBPMNAnnotationModel >> text [

	^ self name
]

{ #category : 'accessing' }
OPBPMNAnnotationModel >> text: aString [

	^ self name: aString
]
