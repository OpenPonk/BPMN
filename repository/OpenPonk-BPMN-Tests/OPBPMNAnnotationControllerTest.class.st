"
I am a unit test class verifying the behavior of OPBPMNAnnotationController, checking description name forms and canvas interaction.
"
Class {
	#name : 'OPBPMNAnnotationControllerTest',
	#superclass : 'OPBPMNNodeControllerTest',
	#category : 'OpenPonk-BPMN-Tests-Controllers',
	#package : 'OpenPonk-BPMN-Tests',
	#tag : 'Controllers'
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
OPBPMNAnnotationControllerTest >> testBuildEditorFormBindsText [

	| annotationModel annotationViewModel form |
	annotationModel := OPBPMNAnnotationModel new text: 'bravo'.
	annotationViewModel := OPBPMNAnnotationViewModel new model: annotationModel.
	controller viewModel: annotationViewModel.
	form := OPPropertiesForm new.
	form viewModel: controller.

	self assert: (form bindings collect: #selector as: Array) equals: #( #text ).
	self assert: form bindings first presenter text equals: 'bravo'.
	controller propertyNamed: #text put: 'charlie'.
	self assert: annotationModel text equals: 'charlie'
]

{ #category : 'tests' }
OPBPMNAnnotationControllerTest >> testUpdateRenderFromModelRendersTextImmediately [

	| annotationModel annotationShape canvas renderedLabelText expectedExtent |
	annotationModel := OPBPMNAnnotationModel new.
	annotationModel text: 'SLA: 24 hours'.
	annotationShape := OPBPMNAnnotationShape new.
	annotationShape modelElement: annotationModel.
	canvas := RSCanvas new.
	annotationShape renderIn: canvas.
	annotationShape updateRenderFromModel.

	renderedLabelText := (annotationShape instVarNamed: 'labeled')
		                     ifNotNil: [ :activeLabeled | activeLabeled labelShape text ]
		                     ifNil: [ '' ].

	self assert: renderedLabelText equals: 'SLA: 24 hours'.
	expectedExtent := (annotationShape instVarNamed: 'labeled') labelShape extent + (annotationShape textPadding * 2) max:
		                  annotationShape minExtent.
	self assert: annotationShape roassalShape extent equals: expectedExtent.
	self deny: annotationShape roassalShape width equals: annotationShape minExtent x
]
