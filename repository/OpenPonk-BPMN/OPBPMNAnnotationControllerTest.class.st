"
I am a unit test class verifying the behavior of OPBPMNAnnotationController, checking description name forms and canvas interaction.
"
Class {
	#name : 'OPBPMNAnnotationControllerTest',
	#superclass : 'OPBPMNNodeControllerTest',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

{ #category : 'constants' }
OPBPMNAnnotationControllerTest class >> diagramElementClass [

	^ OPBPMNAnnotationShape
]

{ #category : 'constants' }
OPBPMNAnnotationControllerTest >> controllerClass [

	^ OPBPMNAnnotationController
]

{ #category : 'constants' }
OPBPMNAnnotationControllerTest >> modelClass [

	^ OPBPMNAnnotationModel
]

{ #category : 'tests' }
OPBPMNAnnotationControllerTest >> testDescriptionName [

	| diagramElement |
	model := Mock new.
	model stub class willReturn: self modelClass.
	model stub text willReturn: 'bravo'.
	diagramElement := Mock new.
	diagramElement stub class willReturn: self diagramElementClass.
	controller diagramController: diagramController.
	controller model: model.
	controller diagramElement: diagramElement.
	controller viewModel descriptionName accessor
		write: 'charlie'
		to: controller.
	model should receive text: 'charlie'.
	self
		assert:
		(controller viewModel descriptionName accessor read: controller)
		equals: 'bravo'.
	diagramElement should receive modelChanged
]
