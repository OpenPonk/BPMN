"
I am the core plugin class for the OpenPonk BPMN editor. I register the BPMN diagram controllers, models, layouters, and default UI tools into the OpenPonk environment.
"
Class {
	#name : 'OPBPMNPlugin',
	#superclass : 'OPPlugin',
	#category : 'OpenPonk-BPMN-Plugin',
	#package : 'OpenPonk-BPMN',
	#tag : 'Plugin'
}

{ #category : 'exporting' }
OPBPMNPlugin class >> exportPackage: aPackageOrController [
	| baseName |
	baseName := (aPackageOrController respondsTo: #name)
		ifTrue: [ aPackageOrController name ]
		ifFalse: [
			(aPackageOrController respondsTo: #model)
				ifTrue: [
					aPackageOrController model ifNotNil: [ :model |
						(model respondsTo: #name) ifTrue: [ model name ] ] ] ].
	(baseName isNil or: [ baseName trimBoth isEmpty ]) ifTrue: [ baseName := 'export' ].
	OPExportFileDialog
		exportBlock: [ OPBPMNXMLWriter toString: aPackageOrController ]
		defaultFileName: (FileNameSanitizer sanitize: baseName trimBoth) , '.bpmn'
		extensions: #( bpmn xml )
		named: 'BPMN XML files'
		title: 'Choose a BPMN file to export to'
]

{ #category : 'accessing' }
OPBPMNPlugin class >> repositoryName [
	^ #BPMN
]

{ #category : 'accessing' }
OPBPMNPlugin >> diagramControllerClass [
	^ OPBPMNDiagramController
]

{ #category : 'templates' }
OPBPMNPlugin >> exampleProjectTemplates [
	"Answers example project templates for BPMN process diagrams."

	^ { 
		(OPProjectTemplate
			named: 'Order Fulfillment'
			icon: self icon
			modelFactory: [ OPBPMNExamples exampleOrderFulfillment ]
			isExample: true) }
]

{ #category : 'accessing' }
OPBPMNPlugin >> icon [
	^ OPBPMNIcon current logo
]

{ #category : 'accessing' }
OPBPMNPlugin >> layouterClass [
	"Create your own subclass of OPLayouter or use OPNoLayouter which does nothing"
	^ OPBPMNLayouter
]

{ #category : 'accessing' }
OPBPMNPlugin >> modelClass [
	^ OPBPMNModel
]

{ #category : 'accessing' }
OPBPMNPlugin >> modelSerializerClass [
	^ OPStonModelSerializer
]

{ #category : 'accessing' }
OPBPMNPlugin >> name [
	^ 'BPMN'
]

{ #category : 'testing' }
OPBPMNPlugin >> supportsHidingElements [
	^ true
]
