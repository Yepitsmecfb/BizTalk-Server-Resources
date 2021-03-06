USE [BizTalkMgmtDb]
GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteBackupHistory]    Script Date: 30/04/2014 12:07:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_DeleteBackupHistoryAndMarkLogsHistory] @DaysToKeep smallint = null, @UseLocalTime bit = 0
AS
 BEGIN
	set nocount on
	IF @DaysToKeep IS NULL OR @DaysToKeep <= 0
		RETURN
	/*
		Only delete full sets
		If a set spans a day such that some items fall into the deleted group and the other don't don't delete the set
		
		Delete history only if history of full Backup exists at a later point of time
		why: history of full backup is used in sp_BackupAllFull_Schedule to check if full backup of databases is required or not. 
		If history of full backup is not present, job will take a full backup irrespective of other options (frequency, Backup hour)
	*/
		
	declare @PurgeDateTime datetime
	if (@UseLocalTime = 0)
		set @PurgeDateTime = DATEADD(dd, -@DaysToKeep, GETUTCDATE())
	else
		set @PurgeDateTime = DATEADD(dd, -@DaysToKeep, GETDATE())
	
	DELETE [dbo].[adm_BackupHistory] 
	FROM [dbo].[adm_BackupHistory] [h1]
	WHERE 	[BackupDateTime] < @PurgeDateTime
	AND	[BackupSetId] NOT IN ( SELECT [BackupSetId] FROM [dbo].[adm_BackupHistory] [h2] WHERE [h2].[BackupSetId] = [h1].[BackupSetId] AND [h2].[BackupDateTime] >= @PurgeDateTime)
	AND EXISTS( SELECT TOP 1 1 FROM [dbo].[adm_BackupHistory] [h2] WHERE [h2].[BackupSetId] > [h1].[BackupSetId] AND [h2].[BackupType] = 'db')

	/****** Delete MarkLog History from BAMAlertsApplication database ******/
	DELETE FROM [BAMAlertsApplication].[dbo].[MarkLog]
    WHERE DATEDIFF(day, REPLACE(SUBSTRING([MarkName],5,10),'_',''), GETDATE()) > @DaysToKeep

	/****** Delete MarkLog History from BAMArchive database* *****/
	DELETE FROM [BAMArchive].[dbo].[MarkLog]
	WHERE DATEDIFF(day, REPLACE(SUBSTRING([MarkName],5,10),'_',''), GETDATE()) > @DaysToKeep

	/****** Delete MarkLog History from BAMPrimaryImport database ******/
	DELETE FROM [BAMPrimaryImport].[dbo].[MarkLog]
	WHERE DATEDIFF(day, REPLACE(SUBSTRING([MarkName],5,10),'_',''), GETDATE()) > @DaysToKeep

	/****** Delete MarkLog History from BizTalkDTADb database ******/
	DELETE FROM [BizTalkDTADb].[dbo].[MarkLog]
	WHERE DATEDIFF(day, REPLACE(SUBSTRING([MarkName],5,10),'_',''), GETDATE()) > @DaysToKeep

	/****** Delete MarkLog History from BizTalkMgmtDb database ******/
	DELETE FROM [BizTalkMgmtDb].[dbo].[MarkLog]
	WHERE DATEDIFF(day, REPLACE(SUBSTRING([MarkName],5,10),'_',''), GETDATE()) > @DaysToKeep

	/****** Delete MarkLog History from BizTalkMsgBoxDb database ******/
	DELETE FROM [BizTalkMsgBoxDb].[dbo].[MarkLog]
	WHERE DATEDIFF(day, REPLACE(SUBSTRING([MarkName],5,10),'_',''), GETDATE()) > @DaysToKeep

	/****** Delete MarkLog History from BizTalkRuleEngineDb database ******/
	DELETE FROM [BizTalkRuleEngineDb].[dbo].[MarkLog]
	WHERE DATEDIFF(day, REPLACE(SUBSTRING([MarkName],5,10),'_',''), GETDATE()) > @DaysToKeep

	/****** Delete MarkLog History from SSODB database ******/
	DELETE FROM [SSODB].[dbo].[MarkLog]
	WHERE DATEDIFF(day, REPLACE(SUBSTRING([MarkName],5,10),'_',''), GETDATE()) > @DaysToKeep
 END
