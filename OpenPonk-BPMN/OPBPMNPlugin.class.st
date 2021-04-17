Class {
	#name : #OPBPMNPlugin,
	#superclass : #OPPlugin,
	#category : #'OpenPonk-BPMN-Adapters'
}

{ #category : #toolbar }
OPBPMNPlugin class >> exportPackage: aPackage [
	FDSaveFileDialog new
		whenSelected: [ :file | 
			file
				ensureDelete;
				writeStreamDo: [ :stream | stream << (OPBPMNXMLWriter toString: aPackage layout: OPBPMNDiagramController  )].
			self inform: 'Exported to ' , file fullName ];
		extensionFilters:
			{'XML files' -> #(bpmn xml).
			'All files' -> #()};
		defaultFolder: FileLocator imageDirectory asFileReference;
		open
]

{ #category : #accessing }
OPBPMNPlugin class >> toolbarMenu: aBuilder [
	<opEditorToolbarMenu: #OPBPMNPlugin>
	(aBuilder item: 'Export do XML')
		icon: (self iconNamed: #help);
		action: [ HelpBrowser openOn: OPFsmHelp ]
]

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
