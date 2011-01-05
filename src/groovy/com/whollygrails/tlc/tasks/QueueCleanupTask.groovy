/*
 *  Copyright 2010 Wholly Grails.
 *
 *  This file is part of the Three Ledger Core (TLC) software
 *  from Wholly Grails.
 *
 *  TLC is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  TLC is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with TLC.  If not, see <http://www.gnu.org/licenses/>.
 */
package com.whollygrails.tlc.tasks

import com.whollygrails.tlc.corp.QueuedTask
import com.whollygrails.tlc.corp.QueuedTaskParam
import com.whollygrails.tlc.corp.QueuedTaskResult
import com.whollygrails.tlc.corp.Task
import com.whollygrails.tlc.sys.TaskExecutable

class QueueCleanupTask extends TaskExecutable {

    def execute() {
        def now = new Date()
        def count = 0
        def cal = Calendar.getInstance()
        def tasks = []
        Task.findAll().each {tsk ->
            cal.setTime(now)
            cal.add(Calendar.DAY_OF_MONTH, -tsk.retentionDays)
            yield()
            QueuedTask.findAllByTaskAndCompletedAtLessThanEquals(tsk, cal.getTime()).each {queued ->
                tasks << queued
            }
        }

        tasks.each {task ->
            QueuedTask.withTransaction {status ->
                QueuedTaskParam.executeUpdate('delete from QueuedTaskParam where queued = ?', [task])
                QueuedTaskResult.executeUpdate('delete from QueuedTaskResult where queued = ?', [task])
                QueuedTask.executeUpdate('delete from QueuedTask where id = ?', [task.id])
            }

            yield()
            count++
        }

        results.count = count
    }
}

