Class {
	#name : 'OPBPMNAnnotationControllerTest',
	#superclass : 'OPBPMNNodeControllerTest',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

{ #category : 'constants' }
OPBPMNAnnotationControllerTest >> controllerClass [

	^ OPBPMNAnnotationController
]

{ #category : 'constants' }
OPBPMNAnnotationControllerTest >> diagramElementClass [

	^ OPBPMNAnnotationShape
]

{ #category : 'constants' }
OPBPMNAnnotationControllerTest >> modelClass [

	^ OPBPMNAnnotationModel
]

{ #category : 'tests' }
OPBPMNAnnotationControllerTest >> testDescriptionName [

	| diagramElement |
	model := Mock new.
	model stub text willReturn: 'bravo'.
	diagramElement := Mock new.
	controller model: model.
	controller diagramElement: diagramElement.
	controller diagramController: diagramController.
	controller descriptionName accessor write: 'charlie' to: controller.
	model should receive text: 'charlie'.
	self
		assert: (controller descriptionName accessor read: controller)
		equals: 'bravo'.
	diagramElement should receive modelChanged
]
