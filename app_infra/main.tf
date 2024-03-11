resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket        = "flask-demo-codepipeline-bucket-hakan"
  force_destroy = true
}

resource "aws_iam_role" "codepipeline_role" {
  name = "flask_codepipeline_role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "codepipeline.amazonaws.com" }
      Sid       = "TrustPolicyStatementThatAllowsEC2ServiceToAssumeTheAttachedRole"
    }]
  })
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name   = "flask_codepipeline_policy"
  role   = aws_iam_role.codepipeline_role.id
  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:GetBucketVersioning",
          "s3:PutObject",
          "s3:PutObjectAcl",
          "iam:PassRole",
        ]
        Effect   = "Allow"
        Resource = [
          aws_s3_bucket.codepipeline_bucket.arn,
          "${aws_s3_bucket.codepipeline_bucket.arn}/*",
        ]
      },
      {
        Effect   = "Allow"
        Action   = ["codebuild:BatchGetBuilds", "codebuild:StartBuild"]
        Resource = "*"
      }
    ]
  })
}

resource "aws_codepipeline" "codepipeline" {
  name     = "flask_pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
    encryption_key {
      id   = aws_kms_key.flask_app_s3_kms_key.arn
      type = "KMS"
    }
  }

  stage {
    name = "Source"
    action {
      name             = "SourceAction"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]
      configuration    = {
        Owner      = var.github_repo_owner
        Repo       = var.github_repo_name
        Branch     = var.github_branch
        OAuthToken = var.github_oauth_token
      }
    }
  }

  stage {
    name = "Build"
    action {
      name             = "Build"

      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"
      configuration = {
        ProjectName = aws_codebuild_project.flask_app.name
      }
    }
  }
}

resource "aws_codebuild_project" "flask_app" {
  name          = "flask-app"
  description   = "Builds a flask application"
  service_role  = aws_iam_role.codebuild_role.arn
  build_timeout = "5"
  artifacts {
    type = "CODEPIPELINE"
  }
  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true
  }
  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.yml"
  }
}


resource "aws_iam_role" "codebuild_role" {
  name               = "flask_codebuild_role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
        Effect    = "Allow"
        Sid       = "TrustPolicyStatementThatAllowsEC2ServiceToAssumeTheAttachedRole"
      },
    ]
  })
}

resource "aws_iam_role_policy" "codebuild_policy" {
  name = "flask_codebuild_policy"
  role = aws_iam_role.codebuild_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
        Effect   = "Allow"
      },
      {
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:GetBucketVersioning",
          "s3:PutObject"
        ]
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.codepipeline_bucket.bucket}",
          "arn:aws:s3:::${aws_s3_bucket.codepipeline_bucket.bucket}/*"
        ]
        Effect   = "Allow"
      },
      {
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:GetAuthorizationToken",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]
        Resource = ["*"]
        Effect   = "Allow"
      },
      {
        Action = [
          "ecs:UpdateService",
          "iam:GetRole",
          "iam:PassRole"
        ]
        Resource = ["*"]
        Effect   = "Allow"
      },
      {
        Effect   = "Allow"
        Action   = [
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ]
        Resource = aws_kms_key.flask_app_s3_kms_key.arn
      },
      {
        Effect = "Allow"
        Action = [
          "codebuild:CreateReportGroup",
          "codebuild:CreateReport",
          "codebuild:BatchPutTestCases",
          "codebuild:UpdateReport",
          "codebuild:BatchGetReports"
        ]
        Resource = "*"
      } 
    ]
  })
}
