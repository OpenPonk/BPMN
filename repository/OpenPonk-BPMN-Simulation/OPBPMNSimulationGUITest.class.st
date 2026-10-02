"
OPBPMNSimulationGUITest verifies presenter lifecycle, simulation hooks, and diagram element color updates during simulation.
"
Class {
	#name : 'OPBPMNSimulationGUITest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-BPMN-Simulation-Tests',
	#package : 'OpenPonk-BPMN-Simulation',
	#tag : 'Tests'
}

{ #category : 'tests' }
OPBPMNSimulationGUITest >> testUpdateColorsWithPoolShapeDoesNotFail [
	| project projectController diagramController rootModel poolModel poolController simulationGUI |
	rootModel := OPBPMNModel new name: 'Process Model'.
	poolModel := OPBPMNPoolModel new name: 'Main Pool'.
	rootModel add: poolModel.

	project := OPProject new.
	project addModel: rootModel.
	projectController := OPProjectController forProject: project.

	diagramController := OPBPMNDiagramController new.
	diagramController canvasPresenter: (OPCanvasPresenter new
		canvas: RSCanvas new;
		yourself).
	diagramController diagramElement: (OPOpenPonkDiagram forModelElement: rootModel).
	projectController addDiagramController: diagramController.
	diagramController model: rootModel.

	poolController := OPBPMNPoolController new.
	poolController diagramController: diagramController.
	poolController model: poolModel.
	diagramController addController: poolController.
	poolController
		createDiagramElement;
		renderDiagramElement.

	simulationGUI := OPBPMNSimulationGUI basicNew.
	simulationGUI instVarNamed: 'diagramController' put: diagramController.
	simulationGUI instVarNamed: 'diagramSimulator' put: (OPBPMNSimulator model: rootModel).

	simulationGUI updateColors
]
