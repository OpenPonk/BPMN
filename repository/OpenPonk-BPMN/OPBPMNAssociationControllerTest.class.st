"
I am a unit test class verifying the correct source/target assignments and clipboard copy/paste behaviors of OPBPMNAssociationController.
"
Class {
	#name : 'OPBPMNAssociationControllerTest',
	#superclass : 'OPBPMNEdgeControllerTest',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

{ #category : 'constants' }
OPBPMNAssociationControllerTest class >> diagramElementClass [

	^ OPBPMNAssociationShape
]

{ #category : 'initialization' }
OPBPMNAssociationControllerTest >> assignModelSource [

	super assignModelSource.
	model source addAssociation: model
]

{ #category : 'initialization' }
OPBPMNAssociationControllerTest >> assignModelTarget [

	super assignModelTarget.
	model target addAssociation: model
]

{ #category : 'constants' }
OPBPMNAssociationControllerTest >> controllerClass [

	^ OPBPMNAssociationController
]

{ #category : 'constants' }
OPBPMNAssociationControllerTest >> modelClass [

	^ OPBPMNAssociationModel
]

{ #category : 'constants' }
OPBPMNAssociationControllerTest >> sourceControllerClass [

	^ OPBPMNActivityController
]

{ #category : 'constants' }
OPBPMNAssociationControllerTest >> sourceModelClass [

	^ OPBPMNActivityModel
]

{ #category : 'constants' }
OPBPMNAssociationControllerTest >> targetControllerClass [

	^ OPBPMNAnnotationController
]

{ #category : 'constants' }
OPBPMNAssociationControllerTest >> targetModelClass [

	^ OPBPMNAnnotationModel
]

{ #category : 'tests - ui interaction' }
OPBPMNAssociationControllerTest >> testBeingCopiedWithDiagram [

	| diagram diagramElement diagramControllerOfCopy |
	self assertEmpty: diagramController controllers.
	self showInDiagram.
	diagram := diagramController diagramElement.
	diagramElement := controller diagramElement.
	self assert: (diagramController hasControllerForModel: self model).
	self
		assertCollection: diagram allOwnedElements
		includesAll: { diagramElement }.
	self
		assertCollection: diagramController controllers
		includesAll: { controller }.
	diagramControllerOfCopy := self diagramControllerClass new.
	diagramControllerOfCopy viewModelRegistry:
		(OPViewModelRegistry forProject: diagramController project).
	diagramControllerOfCopy model: diagramController model.
	self
		shouldnt: [ diagramControllerOfCopy diagramElement: diagram newCopy ]
		raise: OPInvalidWarning.
	diagramControllerOfCopy canvasPresenter: (OPCanvasPresenter new
			 canvas: RSCanvas new;
			 yourself).
	diagramControllerOfCopy diagramFocused.
	self
		assertCollection:
			(diagramControllerOfCopy diagram allOwnedElements collect:
				 #modelElement)
		hasSameElements:
		(diagramController diagram allOwnedElements collect: #modelElement).
	self
		assertCollection:
		(diagramControllerOfCopy controllers collect: #model)
		hasSameElements: (diagramController controllers collect: #model)
]
