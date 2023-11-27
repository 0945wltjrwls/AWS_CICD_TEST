
# 1. AWS CodeCommit = SourceCode를 CodeBuild에서 빌드하고 Artitecture를 S3에 저장
resource "aws_codecommit_repository" "PROJECT_CodeCommit_JSJ980412" {
  repository_name = "PROJECT_CodeCommit_JSJ980412"
  description     = "CICD For MyMiniProject "
}




# 3. AWS CodeBuild = S3에 저장까지 정상적으로 작동이 되었다면 확인후 배포를 준비

resource "aws_codebuild_project" "Project_CodeBuild_JSJ980412" {
  name = "Project_CodeBuild_JSJ980412"                             # CodeBuild 프로젝트의 이름을 지정
  description = "CICD Used CodeBuild For MyMiniProject"
  service_role = aws_iam_role.CodeBuildRole.arn

  source {
    type            = "GITHUB"
    location        = var.Github_repo_url
    git_clone_depth = 1 
    auth {
      type = "TOKEN"
      resource = "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"  # SSM 파라미터에 저장된 GitHub OAuth 토큰 사용
      }
    }
  
  artifacts {
    type = "NO_ARTIFACTS"                        # 빌드 결과물이 없는 경우 NO_ARTIFACTS로 설정합니다.
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"                   # 빌드에 사용할 컴퓨팅 리소스 유형을 지정하세요.
    image        = "aws/codebuild/standard:4.0"             # 빌드 환경에 사용할 이미지를 선택하세요.
    type         = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"               # 특권 모드를 사용하지 않는 경우 false로 설정합니다.
    privileged_mode = true
  }
  
  build_timeout = 60                                        # 빌드가 최대로 실행될 시간(분)을 지정하세요.
}

# 4. AWS CodeDeploy = EC2에 배포









# # 1. AWS CodePipeline = User가 깃허브에 code를 푸시하면 CodePipeline에서 이를 트리거로 인식하여 작동
# resource "aws_codepipeline" "example_pipeline" {
#   name     = "example-pipeline"
#   role_arn = aws_iam_role.pipeline.arn

#   artifact_store {
#     location = "example-pipeline-artifacts"
#     type     = "S3"
#   }

#   stage {
#     name = "Source"

#     action {
#       name             = "SourceAction"
#       category         = "Source"
#       owner            = "AWS"
#       provider         = "CodeCommit"
#       version          = "1"
#       output_artifacts = ["source_output"]
#     }
#   }

#   stage {
#     name = "Build"

#     action {
#       name             = "BuildAction"
#       category         = "Build"
#       owner            = "AWS"
#       provider         = "CodeBuild"
#       input_artifacts  = ["source_output"]
#       output_artifacts = ["build_output"]
#       configuration = {
#         ProjectName = aws_codebuild_project.example_project.name
#       }
#     }
#   }
# }