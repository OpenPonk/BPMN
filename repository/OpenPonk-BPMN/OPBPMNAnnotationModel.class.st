Class {
	#name : 'OPBPMNAnnotationModel',
	#superclass : 'OPBPMNNodeModel',
	#category : 'OpenPonk-BPMN-Models',
	#package : 'OpenPonk-BPMN',
	#tag : 'Models'
}

{ #category : 'testing' }
OPBPMNAnnotationModel >> isEdge [

	^ false
]

{ #category : 'testing' }
OPBPMNAnnotationModel >> isNode [

	^ true
]

{ #category : 'accessing' }
OPBPMNAnnotationModel >> nodes [

	^ {  }
]

{ #category : 'accessing' }
OPBPMNAnnotationModel >> outgoing [

	^ self elements select: [ :each | each source = self ]
]

{ #category : 'accessing' }
OPBPMNAnnotationModel >> text [

	^ self name
]

{ #category : 'accessing' }
OPBPMNAnnotationModel >> text: aString [

	^ self name: aString
]
