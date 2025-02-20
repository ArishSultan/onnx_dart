import 'dart:ffi';

import 'bindings.dart';
import 'typedefs.dart';

extension TypedExtensionOrtApi on OrtApi {
  // [OrtEnv] Methods
  CreateEnv get createEnv => this.CreateEnv.asFunction(isLeaf: true);

  // [OrtAllocator]
  GetAllocatorWithDefaultOptions get getAllocatorWithDefaultOptions =>
      this.GetAllocatorWithDefaultOptions.asFunction(isLeaf: true);

  AllocatorFree get allocatorFree =>
      this.AllocatorFree.asFunction(isLeaf: true);

  // [OrtSession] Methods
  CreateSession get createSession =>
      this.CreateSession.asFunction(isLeaf: true);

  CreateSessionFromArray get createSessionFromArray =>
      this.CreateSessionFromArray.asFunction(isLeaf: true);

  SessionGetModelMetadata get sessionGetModelMetadata =>
      this.SessionGetModelMetadata.asFunction(isLeaf: true);

  SessionGetModelIOCount get sessionGetInputCount =>
      this.SessionGetInputCount.asFunction(isLeaf: true);

  SessionGetModelIOName get sessionGetInputName =>
      this.SessionGetInputName.asFunction(isLeaf: true);

  SessionGetModelIoTypeInfo get sessionGetInputTypeInfo =>
      this.SessionGetInputTypeInfo.asFunction(isLeaf: true);

  SessionGetModelIOCount get sessionGetOutputCount =>
      this.SessionGetOutputCount.asFunction(isLeaf: true);

  SessionGetModelIOName get sessionGetOutputName =>
      this.SessionGetOutputName.asFunction(isLeaf: true);

  SessionGetModelIoTypeInfo get sessionGetOutputTypeInfo =>
      this.SessionGetOutputTypeInfo.asFunction(isLeaf: true);

  // [OrtSessionOptions] methods
  CreateSessionOptions get createSessionOptions =>
      this.CreateSessionOptions.asFunction(isLeaf: true);

  // [OrtModelMetadata] Methods
  ModelMetadataGetVersion get modelMetadataGetVersion =>
      this.ModelMetadataGetVersion.asFunction(isLeaf: true);

  ModelMetadataGetStringProperty get modelMetadataGetDomain =>
      this.ModelMetadataGetDomain.asFunction(isLeaf: true);

  ModelMetadataGetStringProperty get modelMetadataGetProducerName =>
      this.ModelMetadataGetProducerName.asFunction(isLeaf: true);

  ModelMetadataGetStringProperty get modelMetadataGetGraphName =>
      this.ModelMetadataGetGraphName.asFunction(isLeaf: true);

  ModelMetadataGetStringProperty get modelMetadataGetGraphDescription =>
      this.ModelMetadataGetGraphDescription.asFunction(isLeaf: true);

  ModelMetadataGetCustomMetadataMapKeys
  get modelMetadataGetCustomMetadataMapKeys =>
      this.ModelMetadataGetCustomMetadataMapKeys.asFunction(isLeaf: true);

  ModelMetadataLookupCustomMetadataMap
  get modelMetadataLookupCustomMetadataMap =>
      this.ModelMetadataLookupCustomMetadataMap.asFunction(isLeaf: true);

  // [OrtTypeInfo] Methods
  ReleaseTypeInfo get releaseTypeInfo =>
      this.ReleaseTypeInfo.asFunction(isLeaf: true);

  GetOnnxTypeFromTypeInfo get getOnnxTypeFromTypeInfo =>
      this.GetOnnxTypeFromTypeInfo.asFunction(isLeaf: true);

  CastTypeInfoToTensorInfo get castTypeInfoToTensorInfo =>
      this.CastTypeInfoToTensorInfo.asFunction(isLeaf: true);

  // [OrtTensorTypeAndShapeInfo] Methods
  CreateTensorTypeAndShapeInfo get createTensorTypeAndShapeInfo =>
      this.CreateTensorTypeAndShapeInfo.asFunction(isLeaf: true);

  SetTensorElementType get setTensorElementType =>
      this.SetTensorElementType.asFunction(isLeaf: true);

  SetDimensions get setDimensions =>
      this.SetDimensions.asFunction(isLeaf: true);

  GetTensorElementType get getTensorElementType =>
      this.GetTensorElementType.asFunction(isLeaf: true);

  GetDimensionsCount get getDimensionsCount =>
      this.GetDimensionsCount.asFunction(isLeaf: true);

  GetDimensions get getDimensions =>
      this.GetDimensions.asFunction(isLeaf: true);

  GetSymbolicDimensions get getSymbolicDimensions =>
      this.GetSymbolicDimensions.asFunction(isLeaf: true);

  GetTensorShapeElementCount get getTensorShapeElementCount =>
      this.GetTensorShapeElementCount.asFunction(isLeaf: true);
}
