;with 
cteHist as (
	select h.* from [BizTalkRuleEngineDb].[dbo].[re_deployment_history] h
join (select strname, max(dttimestamp) as dttimestamp from [BizTalkRuleEngineDb].[dbo].[re_deployment_history] group by strname) q on h.strName=q.strName and h.dtTimeStamp=q.dttimestamp
),
ctetDeployed as (
	SELECT StrName, nMajor, nMinor, nStatus
						FROM   (
						   SELECT StrName, nMajor, nMinor, nStatus
								, row_number() OVER(PARTITION BY StrName ORDER BY nMajor, nMinor DESC) AS rn
						   FROM   [BizTalkRuleEngineDb].[dbo].[re_ruleset]
						   ) sub
						WHERE  rn = 1
)
select count(*) as Count from ctetDeployed d
where nStatus = 0