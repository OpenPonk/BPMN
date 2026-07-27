Class {
	#name : 'OPBPMNAnnotationModel',
	#superclass : 'OPModelObject',
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
