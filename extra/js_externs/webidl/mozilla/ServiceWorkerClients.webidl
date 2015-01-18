/* -*- Mode: IDL; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 *
 * The origin of this IDL file is
 * http://slightlyoff.github.io/ServiceWorker/spec/service_worker/index.html
 *
 */

[Exposed=ServiceWorker]
interface ServiceWorkerClients {
  // A list of client objects, identifiable by ID, that correspond to windows
  // (or workers) that are "controlled" by this SW
  [Throws]
  Promise<sequence<ServiceWorkerClient>?> getServiced();
  [Throws]
  Promise<any> reloadAll();
};